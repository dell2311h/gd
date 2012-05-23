module Backend::AgentTasksHelper

  def task_target_path(target)
    if target.kind_of?(Exhibition)
      venue_exhibition_path(target.venue, target)
    else
      venue_event_path(target.venue, target)
    end
  end

end
