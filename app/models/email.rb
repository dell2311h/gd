# == Schema Information
# Schema version: 20110213115125
#
# Table name: queued_emails
#
#  id                :integer(4)      not null, primary key
#  from              :string(255)
#  to                :string(255)
#  last_send_attempt :integer(4)      default(0)
#  mail              :text
#  created_on        :datetime
#  sender_name		 :string
#

class Email < ActiveRecord::Base
  def self.table_name() "queued_emails" end

  after_initialize :callback_before_create

  validates :from, :to, :presence => true, :email_format => true  

 protected

 	def callback_before_create
 		self.from = Venue.current.email if Venue.current && Venue.current.email
 	end

end
