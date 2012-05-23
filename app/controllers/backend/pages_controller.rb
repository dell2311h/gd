class Backend::PagesController < BackendController
  def index
    @pages = Page.paginate :page => params[:page], :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC"
  end
  
  def new
    @page = Page.new
  end
  
  def create
    @page = Page.new params[:page]
    if @page.save
      flash[:notice] = 'Page successfuly created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @page = Page.find params[:id]
  end
  
  def update
    @page = Page.find params[:id]
    if @page.update_attributes params[:page]
      flash[:notice] = 'Page successfuly updated'
      redirect_to backend_pages_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @page = Page.find params[:id]
    @page.destroy
    redirect_to backend_pages_path
  end
end
