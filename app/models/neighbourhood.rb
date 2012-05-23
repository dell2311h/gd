# == Schema Information
# Schema version: 20110213115125
#
# Table name: neighbourhoods
#
#  id         :integer(4)      not null, primary key
#  city_id    :integer(4)      not null
#  name       :string(100)     not null
#  created_at :datetime
#  updated_at :datetime
#  verified   :boolean(1)      default(FALSE)
#  delta      :boolean(1)      default(TRUE)
#

class Neighbourhood < ActiveRecord::Base
    belongs_to :city
    validates_presence_of :city
    validates_presence_of :name

    define_index do
      indexes :name, :sortable => true
      indexes city.name, :as => :city, :sortable => true
      indexes city.region.name, :as => :region_name, :sortable => true
      indexes city.country.name, :as => :country_name, :sortable => true
      indexes :verified, :sortable => true
      
      has :verified, :as => :enabled

      set_property :delta => true
      set_property :min_infix_len => 1
    end
  
    scope :verified, where(:verified => true)

    def country_id
      self.city.region.country_id rescue @country_id
    end
    
    def country_id=(id)
      @country_id = id
    end
    
    def region_id
      self.city.region_id rescue @region_id
    end
    
    def region_id=(id)
      @region_id = id
    end
    
    def city_name
      self.city.name rescue ''
    end
    
    def city_name=(name)
      
    end
end
