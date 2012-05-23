class Backend::RegionGroupingsController < BackendController
  
  def index
    @region_groupings = RegionGrouping.search params[:search], :page => params[:page], :order => (params[:sort_on].to_sym rescue :name), :sort_mode => :desc
  end
  
  def show
    
  end
  
  def new
    @region_grouping = RegionGrouping.new
  end
  
  def create
    @region_grouping = RegionGrouping.new params[:region_grouping]
    if @region_grouping.save
      redirect_to backend_region_groupings_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @region_grouping = RegionGrouping.find params[:id]
  end
  
  def update
    @region_grouping = RegionGrouping.find params[:id]
    if @region_grouping.update_attributes params[:region_grouping]
      redirect_to backend_region_groupings_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @region_grouping = RegionGrouping.find params[:id]
    @region_grouping.destroy
    redirect_to backend_region_groupings_path
  end
  
  def get_cities
     @cities = City.find(:all, :conditions => [ "LOWER(name) LIKE ?", params[:q].downcase + '%' ],  :order => "name ASC").collect {|c| "#{c.name}, #{c.region.code}"} rescue []
     render :text => @cities.join("\n")
  end
  
  def get_city
     @city = City.find(:all, :conditions => [ "name = ?", params[:name].split(',').first ], :include => :region ).delete_if {|c| c.region.code != params[:name].split(', ').last }.first
     render :update do |page|
      page.insert_html :bottom, 'cities_block', :partial => 'city_item', :locals => { :city_item => @city }
      page.call 'resetCityInput'
     end
  end
  
end
