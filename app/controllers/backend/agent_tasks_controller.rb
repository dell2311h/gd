class Backend::AgentTasksController < BackendController
  skip_before_filter :admin_required, :only => [:dashboard, :get_new, :take, :set_status]
  before_filter :agent_required, :only => [:dashboard, :get_new, :take, :set_status]
  
  def dashboard
    @agent_tasks = current_user.tasks.paginate :page => params[:page], :order => "status DESC"
  end

  def get_new
    #@tasks = AgentTask.find(:all, :conditions => {:agent_id => nil}, :group => :exhibition_id)
    @tasks = AgentTask.find_by_sql("SELECT id, target_id, target_type, COUNT(*) AS media_service_count FROM agent_tasks WHERE agent_id IS NULL GROUP BY target_id, target_type").paginate :page => params[:page]
  end

  def take
    if params[:exhibition_id]
      AgentTask.connection.execute("UPDATE agent_tasks SET agent_id=#{current_user.id}, status='new' WHERE target_id=#{params[:exhibition_id]} AND target_type='Exhibition' AND agent_id IS NULL")
    elsif params[:event_id]
      AgentTask.connection.execute("UPDATE agent_tasks SET agent_id=#{current_user.id}, status='new' WHERE target_id=#{params[:event_id]} AND target_type='Event' AND agent_id IS NULL")
    end
    redirect_to dashboard_backend_agent_tasks_path
  end

  def set_status
    @task = AgentTask.find(params[:id])
    if params[:status]=='failed'
      if request.post?
        @task.status = 'failed'
        @task.notes << Note.new do |note|
          note.author = current_user
          note.text = params[:note_text]
        end
        if @task.save
          flash[:notice] =  'Task status changed'
          redirect_to dashboard_backend_agent_tasks_path
        else
          flash[:alert] = @task.errors.full_messages.first
          render :required_note
        end
      else
        @task.status = 'failed'
        render :required_note
      end
    elsif params[:status]=='done'
      if @task.status == 'failed'
        # mark to send email again
        @task.target.update_attribute(:listing_agent_completion_notification_sent, false)
      end
      if @task.update_attribute(:status, 'done')
        flash[:notice] =  'Task status changed'
      else
        flash[:alert] = @task.errors.full_messages.first
      end
      redirect_to dashboard_backend_agent_tasks_path
    end
  end
  
  def index
    @agent_tasks = AgentTask.paginate :page => params[:page], :order => "`#{((params[:sort_on].blank?) ? 'id' : params[:sort_on])}` DESC"
  end

  def new
    @agent_task = AgentTask.new
  end

  def create
    @agent_task = AgentTask.new params[:agent_task]
    if @agent_task.save
      flash[:notice] = 'Media Service succesfully added.'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def edit
    @agent_task = AgentTask.find params[:id]
  end

  def update
    @agent_task = AgentTask.find params[:id]
    if @agent_task.update_attributes params[:agent_task]
      flash[:notice] = 'Agent Task succesfully updated.'
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @agent_task = AgentTask.find params[:id]
    if @agent_task.destroy
      flash[:notice] = 'Agent Task deleted'
      redirect_to :action => 'index'
    end
  end

end
