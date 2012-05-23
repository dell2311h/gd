class Backend::ArtistsController < BackendController
  before_filter :find_venue
  
  def index
    @artists = @venue.artists.paginate :page => params[:page]
  end
  
  def new
    @artist = Artist.new
    @artist.venue = @venue
  end
  
  def create
    @artist = Artist.new params[:artist]
    @artist.venue = @venue
    if @artist.save
      flash[:notice] = 'Artist created'
      redirect_to backend_venue_artists_path(@venue)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @artist = @venue.artists.find params[:id]
  end
  
  def update
    @artist = @venue.artists.find params[:id]
    if @artist.update_attributes params[:artist]
      flash[:notice] = 'Artist updated'
      redirect_to backend_venue_artists_path(@venue)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @artist = @venue.artists.find params[:id]
    @artist.destroy
    redirect_to backend_venue_artists_path(@venue)
  end
  
  protected
    def find_venue
      @venue = Venue.find params[:venue_id]
    end
end
