class UpdateMediaContactEmailsIfBlank < ActiveRecord::Migration
  def self.up
    Venue.find(:all, :conditions => { :media_contact_email => '' }).each do |v|
      v.media_contact_email = v.contact_email
      v.media_contact = v.name if v.media_contact.blank?
      v.save_without_validation!
    end
  end

  def self.down
  end
end
