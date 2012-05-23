class Backend::NotesController < BackendController
  skip_before_filter :admin_required
  before_filter :admin_or_agent_required, :find_task

  def index
    @notes = @task.notes.paginate :page => params[:page]
  end

  def new
    @note = Note.new
    @note.subject = @task
  end

  def create
    @note = Note.new params[:note]
    @note.subject = @task
    @note.author = current_user
    if @note.save
      flash[:notice] = 'Note created'
      redirect_to backend_agent_task_notes_path(@task)
    else
      render :action => 'new'
    end
  end

  def edit
    @note = @task.notes.find params[:id]
  end

  def update
    @note = @task.notes.find params[:id]
    if @note.update_attributes params[:note]
      flash[:notice] = 'Note updated'
      redirect_to backend_agent_task_notes_path(@task)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @note = @task.notes.find params[:id]
    @note.destroy
    redirect_to backend_agent_task_notes_path(@task)
  end

 protected
  def find_task
    @task = AgentTask.find params[:agent_task_id]
  end

end
