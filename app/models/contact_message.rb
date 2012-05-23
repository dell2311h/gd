# == Schema Information
# Schema version: 20110213115125
#
# Table name: contact_messages
#
#  id           :integer(4)      not null, primary key
#  sender_name  :string(255)
#  sender_email :string(255)
#  subject      :string(255)
#  message      :text
#  created_at   :datetime
#  updated_at   :datetime
#  page_id      :integer(4)
#

class ContactMessage < ActiveRecord::Base
  belongs_to :page
  
  validates_presence_of :sender_name
  validates_presence_of :sender_email
  validates_format_of   :sender_email,  :with => Authentication.email_regex
  validates_presence_of :subject
  validates_presence_of :message
  
  apply_simple_captcha :message => "incorrect security key", :add_to_base => false, :on => :create
end
