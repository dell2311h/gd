# == Schema Information
# Schema version: 20110213115125
#
# Table name: media
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Medium < ActiveRecord::Base
  has_many  :exhibitions
  
  @@media_cache = []
  @@media_cache_counter = 0
  
  def self.cached_mediums
    if @@media_cache_counter % 100 == 0
      @@media_cache = Medium.all
    end
    @@media_cache_counter += 1
    @@media_cache
  end
end
