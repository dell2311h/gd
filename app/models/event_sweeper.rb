class EventSweeper < ActionController::Caching::Sweeper
  observe Event

  def after_update(e)
    expire_cache_for(e)
  end
  
  def after_save(e)
    expire_cache_for(e)
  end

  def after_destroy(e)
    expire_cache_for(e)
  end

  private
    def expire_cache_for(e)
      expire_fragment("home_event_#{e.id}_cache")
    end
end