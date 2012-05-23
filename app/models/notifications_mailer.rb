class NotificationsMailer < ActionMailer::Base
  self.delivery_method = :activerecord
  helper :exhibition, :events, :application, :venue

  def ten_days_expiration(venue)
    from  "accounts@#{SITE_URL}"
    @recipients  = venue.email
    @content_type = 'text/html'
    @subject     = "Gallery*dog Reminder: #{venue.exhibitions.expiring_in_ten_days.map(&:title).join(', ')} closing soon"
    @sent_on     = Time.now
    @body[:venue]  = venue
  end
  
  def one_day_expiration(venue)
    from "accounts@#{SITE_URL}"
    @recipients  = venue.email
    @content_type = 'text/html'
    @subject     = "Gallery*dog Reminder: NO EXHIBITIONS POSTED FOR #{venue.name}"
    @sent_on     = Time.now
    @body[:venue]  = venue
  end
  
  def monthly_notification(user, venues)
    from "happydog@#{SITE_URL}"
    @recipients  = user.email
    @content_type = 'text/html'
    @subject     = "#{user.kind_of?(Venue) ? user.name : user.firstname}'s Gallery*dog Favorites Report for #{Time.now.strftime('%B, %Y')}"
    @sent_on     = Time.now
    @body[:user]  = user
    @body[:venues]  = venues
    @body[:page] = Page.find_by_caption('message') rescue nil
  end
  
  def fair_invitation(venue, fair, fair_exhibition)
    from 'fairs@gallerydog.info'
    @recipients  = venue.email
    @bcc         = 'fairs@gallerydog.info'
    @content_type = 'text/html'
    @subject     = "#{venue.name} - Claim your #{fair.name} profile today!  The Gallery*dog Fair Guide launches soon."
    @sent_on     = Time.now
    @body[:venue]  = venue
    @body[:fair]  = fair
    @body[:fair_exhibition] = fair_exhibition
  end

  def listing_agent_publication(user, exhibition_or_event, media_service)
    from "happydog@#{SITE_URL}"
    @recipients  = media_service.email
    @content_type = 'text/html'
    @subject     = "#{exhibition_or_event.class.name} Announcement: #{exhibition_or_event.venue.name} (#{exhibition_or_event.venue.ultra_short_location}): #{exhibition_or_event.title} (via Gallery*dog)"
    @sent_on     = Time.now
    @reply_to   = exhibition_or_event.venue.media_contact_email
    @body[:user]  = user
    @body[:exhibition_or_event]  = exhibition_or_event
    @body[:media_service]  = media_service
  end
  
  def listing_agent_publication_summary(user, exhibition_or_event, media_services = [])
    from "happydog@#{SITE_URL}"
    @recipients  = user.email
    @bcc        = 'listings@gallerydog.com'
    @content_type = 'text/html'
    @subject     = "#{exhibition_or_event.class.name} Announcement: #{exhibition_or_event.venue.name} (#{exhibition_or_event.venue.ultra_short_location}): #{exhibition_or_event.title} (via Gallery*dog)"
    @sent_on     = Time.now
    @reply_to   = 'listings@gallerydog.com'
    @body[:user]  = user
    @body[:exhibition_or_event]  = exhibition_or_event
    @body[:media_services]  = media_services
  end
  
  def listing_agent_completion_for_publication(exhibition_or_event, tasks)
    from "happydog@#{SITE_URL}"
    @recipients  = exhibition_or_event.venue.media_contact_email
    @content_type = 'text/html'
    @subject     = "#{exhibition_or_event.class.name} Listing Agent finished for: #{exhibition_or_event.venue.name} (#{exhibition_or_event.venue.ultra_short_location}): #{exhibition_or_event.title}"
    @sent_on     = Time.now
#    @reply_to   = exhibition_or_event.venue.media_contact_email
    @body[:exhibition_or_event]  = exhibition_or_event
    @body[:tasks]  = tasks
  end

end
