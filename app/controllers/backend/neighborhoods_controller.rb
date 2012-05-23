class Backend::NeighborhoodsController < BackendController
  def index
    @neighborhoods = Neighbourhood.search params[:search], :page => params[:page], :order => (params[:sort_on].to_sym rescue :name), :sort_mode => :desc
  end
  
  def new
    @neighborhood = Neighbourhood.new
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:neighborhood].nil?) ? params[:neighborhood][:country_id] : @countries.first.id ) ] )
  end
  
  def create
    @neighborhood = Neighbourhood.new params[:neighborhood]
    @neighborhood.city = City.find(:first, :conditions => [ 'name = ? and region_id = ?', params[:neighborhood][:city_name], params[:neighborhood][:region_id] ]) rescue nil
    @neighborhood.verified = params[:verified]
    
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:neighborhood].nil?) ? params[:neighborhood][:country_id] : @countries.first.id ) ] )
    
    if @neighborhood.save
      flash[:notice] = 'Neighborhood successfuly created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @neighborhood = Neighbourhood.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:neighborhood].nil?) ? params[:neighborhood][:country_id] : @neighborhood.city.region.country_id ) ] )
    @cities = City.find(:all, :conditions => [ 'region_id = ?', @neighborhood.city.region_id ])
    @neighborhoods = Neighbourhood.find(:all, :conditions => [ 'city_id = ?', @neighborhood.city_id ])
    @neighborhoods.delete(@neighborhood)
  end
  
  def update
    @neighborhood = Neighbourhood.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:neighborhood].nil?) ? params[:neighborhood][:country_id] : @neighborhood.city.region.country_id ) ] )
    @cities = City.find(:all, :conditions => [ 'region_id = ?', @neighborhood.city.region_id ])
    @neighborhoods = Neighbourhood.find(:all, :conditions => [ 'city_id = ?', @neighborhood.city_id ])
    @neighborhoods.delete(@neighborhood)
    
    if params[:replacement][:id].blank?
      if @neighborhood.update_attributes params[:neighborhood]
        flash[:notice] = 'Neighborhood successfuly updated'
        redirect_to backend_neighborhoods_path
      else
        render :action => 'edit'
      end
    else
      users = User.find(:all, :conditions => ['neighbourhood_id = ?', params[:id] ]).map(&:id)
      User.update(users, { :neighbourhood_id => params[:replacement][:id] })
      @neighborhood.destroy if params[:replacement][:id] != params[:id]
      flash[:notice] = 'Neighbourhood was replaced'
      redirect_to :action => 'index'
    end
  end
  
  def verify
    @neighborhood = Neighbourhood.find params[:id]
    @neighborhood.verified = true
    @neighborhood.save
    redirect_back_or_default backend_neighborhoods_path
  end
  
  def destroy
    @neighborhood = Neighbourhood.find params[:id]
    @neighborhood.destroy
    redirect_to :action => 'index'
  end
end
