# == Schema Information
# Schema version: 20110213115125
#
# Table name: pages
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  caption           :string(255)
#  visible           :boolean(1)
#  content           :text
#  created_at        :datetime
#  updated_at        :datetime
#  show_form         :boolean(1)      default(FALSE)
#  default_recipient :string(255)     default("contact@gallerydog.info")
#

class Page < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :caption
  validates_presence_of :default_recipient, :id => Proc.new {|p| p.show_form? }
  # validates_presence_of :content
  has_many :contact_messages
end
