class VenueSweeper < ActionController::Caching::Sweeper
  observe Venue

  def after_update(v)
    expire_cache_for(v)
  end

  def after_destroy(v)
    expire_cache_for(v)
  end

  private
    def expire_cache_for(v)
      expire_fragment("home_venue_#{v.id}_cache")
    end
end