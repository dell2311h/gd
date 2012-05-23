class Backend::VenuesController < BackendController
  require 'fastercsv'
  def index
    conditions = ''
    unless params[:state].blank?
      conditions << " `status` = '#{params[:state]}' "
    end
    unless params[:search].blank?
      field = params[:option] unless params[:option].blank?
      conditions << ' AND ' unless conditions.blank?
      conditions << " `#{field}` LIKE '%#{params[:search]}%' "
    end
    @venues = Venue.paginate :page => params[:page], :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC", :conditions => conditions
  end
  
  def new
    @venue = Venue.new
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:venue].nil?) ? params[:venue][:country_id] : @countries.first.id ) ] )
  end
  
  def create
    @venue = Venue.new params[:venue]
    @venue.status = params[:status]
    @venue.terms_agreed = '1'
    @venue.skip_captcha = true
    @venue.skip_desc_validation = true
    @venue.venue_timetable = VenueTimetable.new(params[:venue_timetable])
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:venue].nil?) ? params[:venue][:country_id] : @countries.first.id ) ] )
    if @venue.save
      @venue.activate!
      flash[:notice] = 'Venue successfuly created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @venue = Venue.find params[:id]
    @venue.venue_timetable = VenueTimetable.new if @venue.venue_timetable.nil?
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!@venue.country_id.nil?) ? @venue.country_id : @countries.first.id ) ] )
  end
  
  def update
    @venue = Venue.find params[:id]
    @venue.status = params[:venue][:status]
    @venue.skip_desc_validation = true
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:venue][:country_id].blank?) ? params[:venue][:country_id] : @countries.first.id ) ] )
    
    if @venue.venue_timetable.update_attributes(params[:venue_timetable]) && @venue.update_attributes(params[:venue])
      flash[:notice] = 'Venue successfuly updated.'
      redirect_to :action => 'index'
    else
      @venue_timetable = @venue.venue_timetable
      render :action => 'edit'
    end
  end
  
  def destroy
   @venues = Venue.find(:all, :conditions => "`id` IN(#{params[:delete_ids]})")
   @venues.each {|a| a.destroy } if @venues.size > 0
   redirect_to :action => 'index'
  end
  
  def get_emails
    if params[:set].blank? || params[:set] == 'all'
      @venue_emails = Venue.find(:all, :select => "name, email")
    elsif params[:set] == 'active'
      @venue_emails = Venue.find(:all, :select => "name, email", :conditions => { :invitation_token => nil })
    elsif params[:set] == 'inactive'
      @venue_emails = Venue.find(:all, :select => "name, email", :conditions => [ '`invitation_token` IS NOT NULL' ] )
    end
    csv_string = FasterCSV.generate do |csv|
      csv << ['Venue Name', 'Email']
      @venue_emails.each do |v|
        csv << [v.name, v.email]
      end
    end
    
    send_data csv_string, :type => "text/plain", 
               :filename=>"#{(params[:set].blank?) ? '' : (params[:set] + '_')}venue_emails_#{Time.now.strftime('%Y_%m_%d')}.csv",
               :disposition => 'attachment'
  end
end
