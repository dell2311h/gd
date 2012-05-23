# == Schema Information
# Schema version: 20110213115125
#
# Table name: region_groupings
#
#  id       :integer(4)      not null, primary key
#  name     :string(255)
#  keywords :text
#  delta    :integer(4)      default(0)
#

class RegionGrouping < ActiveRecord::Base
  has_many :cities
  
  define_index do
    indexes :name, :sortable => true
    indexes :keywords, :sortable => true
    indexes cities(:name), :as => :city_name, :sortable => true

    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  validates_presence_of :name
  validates_presence_of :keywords
  validates_presence_of :cities
  
  def city_names
    cities.map(&:name).join(', ')
  end
  
end
