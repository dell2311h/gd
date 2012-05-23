# == Schema Information
# Schema version: 20110213115125
#
# Table name: cities
#
#  id                 :integer(4)      not null, primary key
#  country_id         :integer(4)      not null
#  region_id          :integer(4)      not null
#  name               :string(45)      not null
#  latitude           :float           not null
#  longitude          :float           not null
#  created_at         :datetime
#  updated_at         :datetime
#  verified           :boolean(1)      default(FALSE)
#  delta              :boolean(1)      default(TRUE)
#  region_grouping_id :integer(4)
#

class City < ActiveRecord::Base
    belongs_to :region
    belongs_to :country
    belongs_to :region_grouping
    has_many :neighbourhoods

    define_index do
      indexes :name, :sortable => true
      indexes region.name, :as => :region_name, :sortable => true
      indexes country.name, :as => :country_name, :sortable => true
      indexes :name, :sortable => true
      indexes :verified, :sortable => true
      
      set_property :delta => true
      set_property :min_infix_len => 1
    end

    def get_name_with_code
      "#{self.name}, #{self.region.code}" rescue ""
    end


end

