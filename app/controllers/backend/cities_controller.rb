class Backend::CitiesController < BackendController
  def index
    @cities = City.search params[:search], :page => params[:page], :order => (params[:sort_on].to_sym rescue :name), :sort_mode => :desc
  end
  
  def new
    @city = City.new
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:city].nil?) ? params[:city][:country_id] : @countries.first.id ) ] )
  end
  
  def create
    @city = City.new params[:city]
    @city.verified = params[:verified]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:city].nil?) ? params[:city][:country_id] : @countries.first.id ) ] )
    if @city.save
      flash[:notice] = 'City successfuly created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @city = City.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:city].nil?) ? params[:city][:country_id] : @city.region.country_id ) ] )
    @cities = City.find(:all, :conditions => [ 'region_id = ?', @city.region_id ])
  end
  
  def update
    @city = City.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:city].nil?) ? params[:city][:country_id] : @city.region.country_id ) ] )
    @cities = City.find(:all, :conditions => [ 'region_id = ?', @city.region_id ])
    if params[:replacement][:id].blank?
      if @city.update_attributes params[:city]
        flash[:notice] = 'City successfuly updated'
        redirect_to backend_cities_path
      else
        render :action => 'edit'
      end
    else
      users = User.find(:all, :conditions => ['city_id = ?', params[:id] ]).map(&:id)
      User.update(users, { :city_id => params[:replacement][:id] })
      hoods = Neighbourhood.find(:all, :conditions => ['city_id = ?', params[:id] ]).map(&:id)
      Neighbourhood.update(hoods, { :city_id => params[:replacement][:id] })
      @city.destroy if params[:replacement][:id] != params[:id]
      flash[:notice] = 'City was replaced'
      redirect_to :action => 'index'
    end
  end
  
  def verify
    @city = City.find params[:id]
    @city.verified = true
    @city.save
    redirect_back_or_default backend_cities_path
  end
  
  def destroy
    @city = City.find params[:id]
    # @users.
    @city.destroy
    redirect_to :action => 'index'
  end
end
