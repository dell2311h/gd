class Backend::UsersController < BackendController
  def index
    conditions = " (`type` = 'User' OR `type` = '') "
    unless params[:state].blank?
      conditions << " AND `status` = '#{params[:state]}' "
    end
    unless params[:search].blank?
      field = params[:option] unless params[:option].blank?
      conditions << ' AND ' unless conditions.blank?
      conditions << " `#{field}` LIKE '%#{params[:search]}%' "
    end
    @users = User.paginate :page => params[:page], :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC", :conditions => conditions
  end
  
  def new
    @user = User.new
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:user].nil?) ? params[:user][:country_id] : @countries.first.id ) ] )
  end
  
  def create
    @user = User.new params[:user]
    @user.status = params[:status]
    @user.terms_agreed = '1'
    @user.type = 'User'
    @user.skip_captcha = true
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:user].nil?) ? params[:user][:country_id] : @countries.first.id ) ] )
    if @user.save
      @user.activate!
      flash[:notice] = 'User successfuly created.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!@user.country_id.nil?) ? @user.country_id : @countries.first.id ) ] )
  end
  
  def update
    @user = User.find params[:id]
    @user.status = params[:user][:status]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:user][:country_id].blank?) ? params[:user][:country_id] : @countries.first.id ) ] )
    
    if @user.update_attributes params[:user]
      flash[:notice] = 'User successfuly updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def destroy
   @users = User.find(:all, :conditions => "`id` IN(#{params[:delete_ids]})")
   @users.each {|a| a.destroy } if @users.size > 0
   redirect_to :action => 'index'
  end
end
