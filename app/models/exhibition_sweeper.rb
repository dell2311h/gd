class ExhibitionSweeper < ActionController::Caching::Sweeper
  observe Exhibition

  def after_update(e)
    expire_cache_for(e)
  end

  def after_upload_image(e)
    expire_cache_for(e)
  end

  def after_destroy(e)
    expire_cache_for(e)
  end

  private
    def expire_cache_for(e)
      if e.for_fair
        expire_fragment("fair_exhibition_#{e.fair_exhibition.id}_for_exhibition_#{e.id}_at_fair_#{e.fair_exhibition.id}_cache")
      end
      expire_fragment("home_exhibition_#{e.id}_cache")
    end
end
