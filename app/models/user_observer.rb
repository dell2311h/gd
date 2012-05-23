class UserObserver < ActiveRecord::Observer
  def after_create(user)
     if user.kind_of?(Venue) && !user.skip_default_email
       UserMailer.deliver_venue_signup_notification(user)
       UserMailer.deliver_venue_signup_notification_to_accountist(user)
     end
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated? if user.kind_of?(Venue)
    UserMailer.deliver_reset_notification(user) if user.recently_reset?
  end
end
