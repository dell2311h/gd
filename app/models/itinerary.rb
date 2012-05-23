# == Schema Information
# Schema version: 20110213115125
#
# Table name: itineraries
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  title      :string(255)
#  note       :text
#  created_at :datetime
#  updated_at :datetime
#

class Itinerary < ActiveRecord::Base
  belongs_to :user
  has_many :favorite_itineraries, :dependent => :destroy
  has_many :favorites, :through => :favorite_itineraries
  validates_presence_of :title
  validates_presence_of :favorites, :message => 'should be selected'
  
  def has_venue?(venue)
    self.favorites.count(:conditions => {:favorite_id => ((venue.kind_of?(Venue)) ? venue.id : venue )} ) > 0
  end
end
