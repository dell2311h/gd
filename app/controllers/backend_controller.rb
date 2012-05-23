class BackendController < ApplicationController
  before_filter :admin_required
  layout 'admin'
  
  def index
  end
  
  protected
    def admin_required
      access_denied unless current_user.kind_of?(Admin)
    end

    def agent_required
      access_denied unless current_user.kind_of?(Agent)
    end

    def admin_or_agent_required
      access_denied unless current_user.kind_of?(Admin) || current_user.kind_of?(Agent)
    end
    
    
    def static_pages
      []
    end
end
