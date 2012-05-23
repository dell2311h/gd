class VenueManager::ExhibitionsController < VenueManager::VenueManagerBaseController
  before_filter { fetch_item_counts_for({:exhibition => 'end', :event => 'end_date', :fair => 'end_date'}) }

  def index
    conditions_str = ""
    conditions_params = []
    if !params[:archive]
      conditions_str << '`end` >= ? and `for_fair` = 0'
      conditions_params << Time.now.since(-1.day).strftime('%Y-%m-%d')
    else
      conditions_str << '`end` <= ? and `for_fair` = 0'
      conditions_params << Time.now.strftime('%Y-%m-%d')
    end
    unless params[:filter].blank?
      conditions_str << "#{(conditions_str.blank?) ? '' : ' and '}`title` like ?"
      conditions_params << "%#{params[:filter]}%"
    end
    @exhibitions = current_venue.exhibitions.where([conditions_str]+conditions_params).order('end DESC').all
  end
  
  def new
    @exhibition = Exhibition.new(:venue => current_venue)
    @event = Event.new
  end
  
  def create
    regroup_params
    @exhibition = Exhibition.new params[:exhibition]
    @exhibition.enabled = (params[:save_as_draft] != '1')
    @exhibition.venue_id = current_venue.id
    @event = Event.new @public_reception_params
    if @exhibition.save && @exhibition.set_public_reception(@event)
      #  If exhibition have been save successful - set default image
      @exhibition.set_default_image(params[:default_image_id])
      content_for :head_js, "parent.$.fn.colorbox.close(); parent.location.reload();".html_safe
    end
    render :action => 'new'
  end
  
  def edit
    @exhibition = Exhibition.find params[:id]
    @event = @exhibition.events.receptions.first || Event.new
  end
  
  def update
    regroup_params
    @exhibition = Exhibition.find params[:id]
    @exhibition.enabled = (params[:save_as_draft] != '1')
    @event = @exhibition.events.receptions.first || Event.new
    if @exhibition.update_attributes(params[:exhibition]) && @exhibition.set_public_reception(@event, @public_reception_params)
      #  If update attributes have been successful - set default image
      @exhibition.set_default_image(params[:default_image_id])
      content_for :head_js, "parent.$.fn.colorbox.close(); parent.location.reload();".html_safe
    end
    render :action => 'edit'
  end
  
  def destroy
    
  end
  
  protected
    def regroup_params
      @public_reception_params = params[:exhibition].delete(:event)
      
      @public_reception_params[:start_time] = DateTime.parse(@public_reception_params[:start_date] + ' ' + @public_reception_params.delete(:'start_time(5i)')) rescue ''
      @public_reception_params[:end_time] = DateTime.parse(@public_reception_params[:start_date] + ' ' + @public_reception_params.delete(:'end_time(5i)')) rescue ''
      
      params[:exhibition][:curator_ids] = params[:curator_ids]
      params[:exhibition][:artist_ids] = params[:artist_ids]
      params[:exhibition][:image_ids] = params[:image_ids]
    end
end
