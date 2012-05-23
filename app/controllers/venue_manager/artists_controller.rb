class VenueManager::ArtistsController < VenueManager::VenueManagerBaseController
  before_filter :before_filter_artist, :only => [:edit, :update, :destroy]

  def index
    if params[:filter].blank?
      @artists = current_venue.artists.sort_by_name 
    else
      @artists = current_venue.artists.search params[:filter],
        :sort_mode => :extended,
        :order => 'lastname ASC, firstname ASC'
    end
  end
  
  def new
    @artist = Artist.new
    @countries = Country.all
  end
  
  def create
    @artist = Artist.new params[:artist]
    @artist.venue_id = current_venue.id
    @countries = Country.all
    respond_to do |format|
      format.html do
        if @artist.save
          content_for :head_js, "parent.notifyArtistAdded(#{@artist.to_json}); parent.$.fn.colorbox.close();".html_safe # close the popup
        end
        render :action => 'new'
      end
    end
  end
  
  def edit
    @countries = Country.all
  end
  
  def update
    respond_to do |format|
      format.html do
        if @artist.update_attributes(params[:artist])
          content_for :head_js, "parent.location.reload(); parent.$.fn.colorbox.close();".html_safe # close the popup
        end
        @countries = Country.all
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    respond_to do |format|
      format.html {}
      format.js do
        render :update do |page|
          if @artist.destroy
            page.call "parent.$.fn.colorbox.close"
            page.call "parent.$('#artist_#{params[:id]}').remove"
            page.call "parent.$.sticky", '<b>Delete artist.</b><p>Artist was removed</p>'
          else
            page.call "parent.$.sticky", "<b>Delete artist.</b><p>#{@artist.errors.full_messages.join(', ')}</p>"
          end
        end
      end
    end    
  end
  
  def autocomplete
    @artists = Artist.search("*#{params[:q]}*", { :with => { :venue_id => current_venue.id } }) rescue []
    respond_to do |format|
      format.json do
        render :json => @artists.collect {|a| { :value => (a.firstname + ' ' + a.lastname), :data => { :id => a.id, :obj => a } } }.to_json
      end
    end
  end

protected

  def before_filter_artist
    @artist = Artist.find params[:id]
  rescue
    respond_to do |format|
      format.html {}
      format.js do 
        render :update do |page| 
          page.call "parent.$.sticky", "<b>Error exception.</b><p>Error getting information. Record not found.</p>"
        end
      end
    end
  end

end
