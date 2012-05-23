# == Schema Information
# Schema version: 20110213115125
#
# Table name: favorite_itineraries
#
#  id           :integer(4)      not null, primary key
#  favorite_id  :integer(4)      not null
#  itinerary_id :integer(4)      not null
#  created_at   :datetime
#  updated_at   :datetime
#

class FavoriteItinerary < ActiveRecord::Base
  belongs_to :favorite
  belongs_to :itinerary
end
