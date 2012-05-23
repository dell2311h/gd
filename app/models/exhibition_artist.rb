# == Schema Information
# Schema version: 20110213115125
#
# Table name: exhibition_artists
#
#  id            :integer(4)      not null, primary key
#  exhibition_id :integer(4)      not null
#  artist_id     :integer(4)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class ExhibitionArtist < ActiveRecord::Base
  belongs_to :exhibition
  belongs_to :artist
end
