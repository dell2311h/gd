# == Schema Information
# Schema version: 20110213115125
#
# Table name: regions
#
#  id         :integer(4)      not null, primary key
#  country_id :integer(4)      not null
#  name       :string(45)      not null
#  code       :string(8)       not null
#  adm1code   :string(4)       not null
#  created_at :datetime
#  updated_at :datetime
#  delta      :boolean(1)      default(TRUE)
#

class Region < ActiveRecord::Base
    belongs_to :country
    has_many :cities

    define_index do
      indexes :name, :sortable => true
      indexes country.name, :as => :country_name, :sortable => true
    end

end
