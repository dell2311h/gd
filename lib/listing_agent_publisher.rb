class ListingAgentPublisher
  attr_accessor :user, :target, :messages

  def initialize(user, target)
    @user = user
    @target = target
  end

  def publish!
    @target.listing_agent_enabled = true
    @target.listing_agent_started_at = Time.now
    @target.save_without_validation!
    @messages = []
    @media_services = @target.venue.media_service_setups.collect(&:media_service)
    at_leat_one_task_created = false
    @target.venue.media_service_setups.each do |media_svc_acc|
      unless media_svc_acc.media_service.form_based
        NotificationsMailer.deliver_listing_agent_publication(@user, @target, media_svc_acc.media_service)
        @messages << "#{@target.class.name} '#{@target.title}' has been enqueued for email publishing to '#{media_svc_acc.media_service.name}'"
        next
      end
      if AgentTask.find(:first, :conditions => {:target_id => @target.id, :target_type => @target.class.name, :media_service_id => media_svc_acc.media_service.id})
        @messages << "#{@target.class.name} '#{@target.title}' was already enqueued for publication to '#{media_svc_acc.media_service.name}'"
        next
      end
      task = AgentTask.new
      task.target = @target
      task.media_service = media_svc_acc.media_service
      if task.save
        @messages << "#{@target.class.name} '#{@target.title}' has been enqueued for manual publishing to '#{task.media_service.name}'"
        at_leat_one_task_created = true
      else
        @messages << "Error publishing '#{@target.title}' to '#{task.media_service.name}':"
        @messages += task.errors.full_messages.map{|e| " -- #{e}"}
      end
    end

    NotificationsMailer.deliver_listing_agent_publication_summary(@user, @target, @media_services) if at_leat_one_task_created
  end


end