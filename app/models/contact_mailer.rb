class ContactMailer < ActionMailer::Base
  def message(message, page)
    @recipients  = page.default_recipient
    @from        = message.sender_email
    @subject     = "Gallery*dog: Contact from #{message.sender_email}"
    @sent_on     = Time.now
    @body[:message]  = message
  end
  
  def sender_confirmation(message)
    @recipients  = message.sender_email
    @from        = "no-reply@#{SITE_URL}"
    @subject     = "gallery*dog -=- Contact form submission notification"
    @sent_on     = Time.now
    @body[:message]  = message
  end

end
