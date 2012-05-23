# == Schema Information
# Schema version: 20110213115125
#
# Table name: favorites
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  itinerary_id :integer(4)
#  favorite_id  :integer(4)
#  title        :string(255)
#  note         :text
#  created_at   :datetime
#  updated_at   :datetime
#

class Favorite < ActiveRecord::Base
  belongs_to  :user
  has_many :favorite_itineraries, :dependent => :destroy
  has_many :itineraries, :through => :favorite_itineraries
  belongs_to :item, :class_name => 'Venue', :foreign_key => 'favorite_id'
end
