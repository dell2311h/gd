class Backend::AdministratorsController < BackendController

  def index
    conditions = ''
    unless params[:state].blank?
      conditions << " `status` = '#{params[:state]}' "
    end
    unless params[:search].blank?
      conditions << ' AND ' unless conditions.blank?
      conditions << " `email` LIKE '%#{params[:search]}%' "
    end
    @administrators = Admin.paginate :page => params[:page], :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC", :conditions => conditions
  end
  
  def new
    @administrator = Admin.new
  end
  
  def create
    @administrator = Admin.new params[:admin]
    @administrator.status = params[:status]
    @administrator.skip_captcha = true
    if @administrator.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @administrator = Admin.find params[:id]
  end
  
  def update
    @administrator = Admin.find params[:id]
    @administrator.status = params[:admin][:status]
    if @administrator.update_attributes params[:admin]
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
   @administrators = Admin.find(:all, :conditions => "`id` IN(#{params[:delete_ids]})")
   @administrators.each {|a| a.destroy } if @administrators.size > 0
   redirect_to :action => 'index'
  end
  
end