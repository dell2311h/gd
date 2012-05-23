# == Schema Information
# Schema version: 20110213115125
#
# Table name: event_types
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  is_custom    :boolean(1)      default(FALSE)
#  is_reception :boolean(1)      default(FALSE)
#  pos          :integer(4)      default(0)
#

class EventType < ActiveRecord::Base
  has_many :events
  default_scope :order => "pos DESC"
end
