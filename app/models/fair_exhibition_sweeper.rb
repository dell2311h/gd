class FairExhibitionSweeper < ActionController::Caching::Sweeper
  observe FairExhibition

  def after_update(fe)
    expire_cache_for(fe)
  end

  def after_destroy(fe)
    expire_cache_for(fe)
  end

  private
    def expire_cache_for(fe)
      expire_fragment("fair_exhibition_#{fe.id}_for_#{((fe.exhibition_id.nil?) ? 'venue' : 'exhibition')}_#{((fe.exhibition_id.nil?) ? fe.venue_id : fe.exhibition_id)}_at_fair_#{fe.fair_id}_cache")
    end
end