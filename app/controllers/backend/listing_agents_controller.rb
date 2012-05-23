class Backend::ListingAgentsController < BackendController
  
  def index
    conditions = ''
    unless params[:state].blank?
      conditions << " `status` = '#{params[:state]}' "
    end
    unless params[:search].blank?
      conditions << ' AND ' unless conditions.blank?
      conditions << " `email` LIKE '%#{params[:search]}%' "
    end
    @listing_agents = Agent.paginate :page => params[:page], :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC", :conditions => conditions
  end
  
  def new
    @listing_agent = Agent.new
  end
  
  def create
    @listing_agent = Agent.new params[:listing_agent]
    @listing_agent.skip_captcha = true
    @listing_agent.really_basic_data = true
    if @listing_agent.save
      redirect_to backend_listing_agents_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @listing_agent = Agent.find params[:id]
  end
  
  def update
    @listing_agent = Agent.find params[:id]
    if @listing_agent.update_attributes params[:listing_agent]
      redirect_to backend_listing_agents_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @listing_agents = Agent.find params[:delete_ids]
    begin
      @listing_agents.each {|a| a.destroy }
    rescue
      
    end
    redirect_to backend_listing_agents_path
  end
  
end
