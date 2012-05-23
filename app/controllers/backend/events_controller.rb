class Backend::EventsController < BackendController
  before_filter :find_venue
  
  def index
    @events = @venue.events.paginate :page => params[:page]
  end
  
  def new
    @event = Event.new
    @event.venue = @venue
  end
  
  def create
    @event = Event.new params[:event]
    @event.venue = @venue
    if @event.save
      flash[:notice] = 'Event created'
      redirect_to backend_venue_events_path(@venue)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @event = @venue.events.find params[:id]
  end
  
  def update
    @event = @venue.events.find params[:id]
    if @event.update_attributes params[:event]
      flash[:notice] = 'Event updated'
      redirect_to backend_venue_events_path(@venue)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @event = @venue.artists.find params[:id]
    @event.destroy
    redirect_to backend_venue_events_path(@venue)
  end
  
  protected
    def find_venue
      @venue = Venue.find params[:venue_id]
    end  
end
