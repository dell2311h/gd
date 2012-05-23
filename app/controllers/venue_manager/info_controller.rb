class VenueManager::InfoController < VenueManager::VenueManagerBaseController
  before_filter :before_filter_venue, :except => [:neighbourhood_autocomplete]

  def details
    @countries = Country.all
    @regions = Region.where(:country_id => ((@venue.country_id.nil?) ? @countries.first.id : @venue.country_id ) ).all
    @cities = City.where(:region_id => ((@venue.region_id.nil?) ? @regions.first.id : @venue.region_id ) ).all
    @neighbourhoods = Neighbourhood.where(:city_id => ((@venue.city_id.nil?) ? @cities.first.id : @venue.city_id ) ).all
    
    if request.post?
      flash[:notice] = @venue.errors.full_messages.join(', ')  unless @venue.update_attributes params[:venue]
      # @venue.reload
    end
  end
  
  def images
    unless request.get?
      flash[:notice] = @venue.errors.full_messages.join(', ') unless @venue.update_attributes params[:venue]
    end
  end
  
  def description
    if request.post?
      @venue.update_attributes params[:venue]
    end
  end
  
  def schedule
    @venue_timetable = @venue.venue_timetable
    if request.post?
      Date::ABBR_DAYNAMES.map(&:downcase).each do |day|
        params[:venue_timetable]["#{day}_open".to_sym] = DateTime.parse(params[:venue_timetable].delete("#{day}_open(5i)".to_sym)).to_time
        params[:venue_timetable]["#{day}_close".to_sym] = DateTime.parse(params[:venue_timetable].delete("#{day}_close(5i)".to_sym)).to_time
      end
      @venue_timetable.update_attributes params[:venue_timetable]
    end
  end
  
  def credentials
    if request.post?
      @venue.update_attributes params[:venue]
    end
  end

  def neighbourhood_autocomplete
    @neighbourhoods = Neighbourhood.search params[:q], :with => {:enabled => true} rescue []
    respond_to do |format|
      format.json do
        render :json => @neighbourhoods.collect {|a| { :value => a.name, :data => { :id => a.id, :obj => a } } }.to_json
      end
    end
  end

protected

  def before_filter_venue
    VenueTimetable.create(:venue_id => current_venue.id) && current_venue.reload unless current_venue.venue_timetable
    @venue = current_venue
  end
  

end
