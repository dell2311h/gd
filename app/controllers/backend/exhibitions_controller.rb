class Backend::ExhibitionsController < BackendController
  before_filter :find_venue
  
  def index
    @exhibitions = @venue.exhibitions.paginate :page => params[:page]
  end
  
  def new
    @exhibition = Exhibition.new
    @exhibition.venue = @venue
  end
  
  def create
    aritst_ids = params[:exhibition].delete(:aritst_ids)
    @artists = @venue.artists.find(aritst_ids) rescue []
    @exhibition = Exhibition.new params[:exhibition]
    @exhibition.venue = @venue
    @exhibition.terms_agreed = '1'
    @exhibition.artists = @artists
    @exhibition.skip_desc_validation = true
    if @exhibition.save
      flash[:notice] = 'Exhibition created'
      redirect_to backend_venue_exhibitions_path(@venue)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @exhibition = @venue.exhibitions.find params[:id]
  end
  
  def update
    aritst_ids = params[:exhibition].delete(:aritst_ids)
    @artists = @venue.artists.find(aritst_ids) rescue []
    @exhibition = @venue.exhibitions.find params[:id]
    @exhibition.artists = @artists
    @exhibition.skip_desc_validation = true
    if @exhibition.update_attributes params[:exhibition]
      flash[:notice] = 'Exhibition updated'
      redirect_to backend_venue_exhibitions_path(@venue)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @exhibition = @venue.exhibitions.find params[:id]
    @exhibition.destroy
    redirect_to backend_venue_exhibitions_path(@venue)
  end
  
  def get_artists
    @artists = @venue.artists.find(:all,
                                              :conditions => [ "LOWER(`artists`.firstname) LIKE ? OR LOWER(`artists`.lastname) LIKE ?", params[:q].downcase + '%', params[:q].downcase + '%' ],
                                              :order => "id ASC", :select => "firstname, lastname").collect {|a| a.firstname + ' ' + a.lastname } rescue []
    render :text => @artists.join("\n")
  end
  
  def get_artist
    name = params[:name].downcase.split(' ')
    if name.size>1
      @artist = @venue.artists.find(:first, :conditions => ['LOWER(artists.firstname) LIKE(?) AND LOWER(artists.lastname) LIKE(?)', name[0], name[1]]) if name.size > 0
    else
      @artist = @venue.artists.find(:first, :conditions => ['LOWER(artists.firstname) LIKE(?) OR LOWER(artists.lastname) LIKE(?)', name[0], name[0]]) if name.size > 0
    end
    render :update do |page|
      page.insert_html :bottom, :artists_block, :partial => 'artist_item', :locals => { :artist_item => @artist } if @artist
      page.call "jQuery('input#artist_name').val", ''
    end
  end
  
  protected
    def find_venue
      @venue = Venue.find params[:venue_id]
    end
  
end
