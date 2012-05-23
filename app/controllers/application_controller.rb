class ApplicationController < ActionController::Base
  protect_from_forgery
  include SimpleCaptcha::ControllerHelpers
  before_filter :static_pages, :region_options
  before_filter :before_filter_venue_setup

  helper_method :current_venue_session, :current_venue, :current_user_session, :current_user
  
  begin
    def rescue_action(exception)
      case exception
      when ::ActionController::RoutingError, ::ActionController::UnknownAction
        then begin
          if exception.to_s =~ /\/images|javascripts|stylesheets\//
            super
          else
            flash[:error] = "Page not found."
            redirect_to root_path
          end
        end
      else super
      end
    end
  end
  
  # FORCE to implement content_for in controller
    def view_context
      super.tap do |view|
        (@_content_for || {}).each do |name,content|
          view.content_for name, content
        end
      end
    end
    def content_for(name, content) # no blocks allowed yet
      @_content_for ||= {}
      if @_content_for[name].respond_to?(:<<)
        @_content_for[name] << content
      else
        @_content_for[name] = content
      end
    end
    def content_for?(name)
      @_content_for[name].present?
    end

  protected

      def redirect_to_mobile
        redirect_to mobile_fair_groupings_path(:subdomain => 'miami')
      end

      def static_pages
        @pages = Page.find :all, :conditions => ['visible = ? ', true]
      end

      def region_options
        @region_options = [RegionGrouping.new(:name => 'choose region')] + RegionGrouping.find(:all)
      end
      
      def access_denied
        flash[:notice] = "You must be logged in to access this page"
        redirect_to new_session_url
      end      
      
      def logged_in?
        !current_user.nil?
      end
      
      # authlogic users
      def current_user_session
        return @current_user_session if defined?(@current_user_session)
        @current_user_session = UserSession.find
      end
      
      def current_user
        return @current_user if defined?(@current_user)
        @current_user = Venue.current
      end

      def require_user
        current_user
        unless current_user
          store_location
          flash[:notice] = "You must be logged in to access this page"
          redirect_to new_session_url
          return false
        end
      end

      def require_no_user
        if current_user
          store_location
          flash[:notice] = "You must be logged out to access this page"
          redirect_to root_url
          return false
        end
      end
      # authlogic users
      
      # authlogic venues
      def current_venue_session
        return @current_venue_session if defined?(@current_venue_session)
        @current_venue_session = VenueSession.find
      end
      
      def before_filter_venue_setup
        # Find the current venue
        Venue.current = current_venue_session && current_venue_session.venue
        @session_key_name = Rails.application.config.session_options[:key]
      end

      def current_venue
        return @current_venue if defined?(@current_venue)
        @current_venue = Venue.current
      end

      def require_venue
        current_venue
        unless current_venue
          store_location
          flash[:notice] = "You must be logged in as venue to access this page"
          redirect_to root_url
          return false
        end
      end

      def require_no_venue
        if current_venue
          store_location
          flash[:notice] = "You must be logged out to access this page"
          redirect_to manage_venue_url
          return false
        end
      end
      # authlogic venues

      def redirect_back_or_default(default)
        redirect_to(session[:return_to] || default)
        session[:return_to] = nil
      end
      
      def store_location
        session[:return_to] = request.request_uri
      end
end
