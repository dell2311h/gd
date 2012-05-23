class Backend::MediaServicesController < BackendController
  def index
    @media_services = MediaService.paginate :page => params[:page] || 1, :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC"
  end
  
  def new
    @media_service = MediaService.new
  end
  
  def create
    @media_service = MediaService.new params[:media_service]
    if @media_service.save
      flash[:notice] = 'Media Service succesfully added.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @media_service = MediaService.find params[:id]
  end
  
  def update
    @media_service = MediaService.find params[:id]
    if @media_service.update_attributes params[:media_service]
      flash[:notice] = 'Media Service succesfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @media_service = MediaService.find params[:id]
    if @media_service.destroy
      flash[:notice] = 'Media Service deleted'
      redirect_to :action => 'index'
    end
  end
end
