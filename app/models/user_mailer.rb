class UserMailer < ActionMailer::Base
  def venue_signup_notification(user)
    setup_email(user)
    @subject     = "Gallery*dog venue account for #{user.name}"
  end

  def venue_signup_notification_to_accountist(user)
    setup_email(user)
    @recipients  = 'accounts@gallerydog.info'
    @subject     = "New Gallery*dog Venue: #{user.name}"
  end
  
  def activation(user)
    setup_email(user)
    @subject     = "#{user.name}'s Gallery*dog account has been activated!"
  end

  def reset_notification(user)
    setup_email(user)
    @subject    += 'Link to reset your password'
    @body[:url]  = "http://#{SITE_URL}/reset/#{user.reset_code}"
  end
 
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "accounts@#{SITE_URL}"
      @subject     = "Gallery*dog notification"
      @sent_on     = Time.now
      @body[:user] = user
    end
end
