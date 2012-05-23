class ActivationsController < ApplicationController
 	before_filter :require_no_user

  def create
    @venue = Venue.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @venue.confirmed?

    if @venue.confirmed!
      flash[:notice] = "Your account has been activated!"
      VenueSession.create(@venue, false) # Log user in manually
      @venue.deliver_welcome!
    else
      flash[:notice] = "Sorry, but your account has not been activated!<br /><p>#{@venue.errors.full_messages.join('<br /><br />')}</p>"     
    end
    redirect_to root_url
  end
end
