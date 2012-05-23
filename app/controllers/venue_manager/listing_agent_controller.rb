class VenueManager::ListingAgentController < VenueManager::VenueManagerBaseController
  def index
    @media_service_groups = MediaService.select('distinct(region)').map(&:region)
    params[:region] = @media_service_groups.first if params[:region].blank?
    @media_services = MediaService.search(params[:filter], :with => { :id => MediaService.select(:id).where(:region => params[:region]).map(&:id) })
    if request.post?
      @media_service_setups = []
      current_venue.media_service_setups.where(:media_service_id => params[:venue][:media_service_setups][:available_media_service_id]).destroy_all
      unless params[:venue][:media_service_setups][:media_service_id].nil?
        params[:venue][:media_service_setups][:media_service_id].each do |id|
          setup = MediaServiceSetup.new(:media_service_id => id, :venue_id => current_venue.id)
          setup.media_site_login = params[:venue][:media_service_setups][:media_site_login][id]
          setup.media_site_password = params[:venue][:media_service_setups][:media_site_password][id]
          setup.save
          @media_service_setups << setup
        end
      end
    else
      @media_service_setups = current_venue.media_service_setups.where(:media_service_id => @media_services.map(&:id))
    end
  end
  
end
