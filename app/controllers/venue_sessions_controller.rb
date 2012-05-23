class VenueSessionsController < ApplicationController
  # before_filter :require_no_venue, :only => [:new, :create]
  before_filter :require_venue, :only => :destroy

  def new
    @venue_session = VenueSession.new
  end

  def create
    @venue_session = VenueSession.new(params[:venue_session])
    if @venue_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default venue_manager_root_url(@venue_session.venue)
    else
      flash[:notice] = "Sorry, could not log in as '#{params[:venue_session][:email]}'. Please try again."
      redirect_to root_path
    end
  end

  def destroy
    current_venue_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_path
  end
end
