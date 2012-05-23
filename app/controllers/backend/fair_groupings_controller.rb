class Backend::FairGroupingsController < BackendController
  require 'fastercsv'
  def index
    @fair_groupings = FairGrouping.search params[:search], :page => params[:page], :order => (params[:sort_on].to_sym rescue :name), :sort_mode => :desc
  end
  
  def new
    @fair_grouping = FairGrouping.new
  end
  
  def create
    @fair_grouping = FairGrouping.new params[:fair_grouping]
    if @fair_grouping.save
      redirect_to backend_fair_groupings_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @fair_grouping = FairGrouping.find params[:id]
  end
  
  def update
    @fair_grouping = FairGrouping.find params[:id]
    if @fair_grouping.update_attributes params[:fair_grouping]
      redirect_to backend_fair_groupings_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @fair_grouping = FairGrouping.find params[:id]
    @fair_grouping.destroy
    redirect_to backend_fair_groupings_path
  end
  
  def get_emails
    @fair_emails = FairExhibition.find(:all, :include => [:venue, :fair],:select => "`fairs`.`name`, `users`.`name`, `users`.`email`")
    csv_string = FasterCSV.generate do |csv|
      csv << ['Fair', 'Venue Name', 'Email']
      @fair_emails.each do |f|
        csv << [f.fair.name, f.venue.name, f.venue.email]
      end
    end
    
    send_data csv_string, :type => "text/plain", 
               :filename=>"fair_emails_#{Time.now.strftime('%Y_%m_%d')}.csv",
               :disposition => 'attachment'
  end
  
end
