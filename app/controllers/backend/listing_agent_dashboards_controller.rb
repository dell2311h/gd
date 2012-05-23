class Backend::ListingAgentDashboardsController < ApplicationController
  before_filter :login_required, :agent_required
  layout 'admin'
  
  def show
    
  end
  
  protected
    def agent_required
      access_denied unless current_user.kind_of?(Agent)
    end
    
    def static_pages
      []
    end
end
