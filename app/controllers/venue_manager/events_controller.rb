require 'pp'
class VenueManager::EventsController < VenueManager::VenueManagerBaseController
  before_filter { fetch_item_counts_for({:exhibition => 'end', :event => 'end_date', :fair => 'end_date'}) }
  
  def index
    conditions_str = ""
    conditions_params = []
    if !params[:archive]
      conditions_str << '`end_date` >= ?'
      conditions_params << Time.now.since(-1.day).strftime('%Y-%m-%d')
    else
      conditions_str << '`end_date` <= ?'
      conditions_params << Time.now.strftime('%Y-%m-%d')
    end
    unless params[:filter].blank?
      conditions_str << "#{(conditions_str.blank?) ? '' : ' and '}`title` like ?"
      conditions_params << "%#{params[:filter]}%"
    end
    @events = current_venue.events.where([conditions_str]+conditions_params).order('end_date DESC').all
  end
  
  def new
    @event = Event.new
  end
  
  def create
    regroup_params
    @event = Event.new params[:event]
    @event.enabled = (params[:save_as_draft] != '1')
    @event.venue_id = current_venue.id
    if @event.save
      #  If event have been save successful - set default image
      @event.set_default_image(params[:default_image_id])
      content_for :head_js, "parent.$.fn.colorbox.close(); parent.location.reload();".html_safe
    end
    render :action => 'new'
  end
  
  def edit
    @event = Event.find params[:id]
  end
  
  def update
    regroup_params
    @event = Event.find params[:id]
    @event.enabled = (params[:save_as_draft] != '1')
    if @event.update_attributes params[:event]
      #  If update attributes have been successful - set default image
      @event.set_default_image(params[:default_image_id])
      # proceed with public reception and images
      content_for :head_js, "parent.$.fn.colorbox.close(); parent.location.reload();".html_safe
    end
    render :action => 'edit'
  end
  
  def destroy
    
  end
  
  protected
    def regroup_params
      params[:event][:image_ids] = params[:image_ids]
      params[:event][:start_time] = DateTime.parse(params[:event][:start_date] + ' ' + params[:event].delete(:'start_time(5i)'))
      params[:event][:end_time] = DateTime.parse(params[:event][:start_date] + ' ' + params[:event].delete(:'end_time(5i)'))
    end
end
