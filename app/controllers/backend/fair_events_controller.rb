class Backend::FairEventsController < BackendController
  before_filter :load_fairs
  
  def index
    @fair_events = @fair.fair_events.search params[:search], { :page => params[:page], :order => (params[:sort_on].to_sym rescue :name), :sort_mode => :desc }
  end
  
  def new
    @fair_event = FairEvent.new
    @fair_event.fair = @fair
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair_event].nil? && !params[:fair_event][:country_id].blank?) ? params[:fair_event][:country_id] : @countries.first.id ) ] )
  end
  
  def create
    @fair_event = FairEvent.new params[:fair_event]
    @fair_event.fair = @fair
    if @fair_event.save
      flash[:notice] = 'Event added.'
      redirect_to :action => 'index'
    else
      @countries =  Country.find(:all)
      @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair_event].nil? && !params[:fair_event][:country_id].blank?) ? params[:fair_event][:country_id] : @countries.first.id ) ] )
      flash[:error] = 'Event was not added.'
      render :action => 'new'
    end
  end
  
  def edit
    @fair_event = FairEvent.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair_event].nil? && !params[:fair_event][:country_id].blank?) ? params[:fair_event][:country_id] : @countries.first.id ) ] )
  end
  
  def update
    @fair_event = FairEvent.find params[:id]
    if @fair_event.update_attributes params[:fair_event]
      flash[:notice] = 'Event saved.'
      redirect_to :action => 'index'
    else
      @countries =  Country.find(:all)
      @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair_event].nil? && !params[:fair_event][:country_id].blank?) ? params[:fair_event][:country_id] : @countries.first.id ) ] )
      flash[:error] = 'Event was not saved.'
      render :action => 'edit'
    end
  end
  
  def destroy
    @fair_event = FairEvent.find params[:id]
    if @fair_event.destroy
      flash[:notice] = 'Event deleted.'
    else
      flash[:error] = 'Event was not deleted.'
    end
    redirect_to :action => 'index'
  end
  
  protected
    def load_fairs
      @fair_grouping = FairGrouping.find(params[:fair_grouping_id])
      @fair = @fair_grouping.fairs.find(params[:fair_id])
    end
end
