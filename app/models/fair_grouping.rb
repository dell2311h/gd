# == Schema Information
# Schema version: 20110213115125
#
# Table name: fair_groupings
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  start_date :date
#  end_date   :date
#  delta      :boolean(1)      default(TRUE)
#  short_name :string(255)     default("")
#

class FairGrouping < ActiveRecord::Base
  has_many :fairs, :dependent => :destroy
  before_update :update_short_name
  define_index do
    indexes :name, :sortable => true
    indexes :short_name, :sortable => true
    indexes :start_date, :as => :start_date, :sortable => true
    indexes :end_date, :as => :end_date, :sortable => true
    
    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  validates_presence_of :name
  validates_presence_of :start_date
  validates_presence_of :end_date
  
  def gmap_object
    map = self.base_gmap_object
    coords = []
    self.fairs.each do |fair|
      address = [
        fair.address,
        (fair.city.name rescue nil),
        (fair.region.name rescue nil),
        (fair.country.name rescue nil)].compact.join(', ')
        
      address_with_newlines = [
        "<b>#{fair.name}</b>",
        fair.address,
        (fair.city.name rescue nil),
        (fair.region.name rescue nil),
        (fair.country.name rescue nil)].compact.join('<br/>')
        
      if fair.lat.nil? || fair.lon.nil?
        fair.fetch_lat_lon
        fair.save_without_validation!
      end
      
      #marker_icon = GIcon.new({:image => 'http://localhost:3000/images/g-star.gif'})
      coords << [fair.lat,fair.lon]
      marker = GMarker.new([fair.lat,fair.lon], { :title => fair.name, :info_window => address_with_newlines } )#, :icon => marker_icon) , :max_width => '100px'
      map.overlay_init(marker)
    end
    
    map.center_zoom_init(coords.first, 10)
    map
  end
  
  def base_gmap_object
    map = GMap.new("map_div_id")
    map.control_init(:small_map => true, :map_type => false, :small_zoom => false, :scale => false)
    map
  end
  
  private
    def update_short_name
      self.short_name = self.name.gsub(/\s*/,'-').gsub(/\|/,'').downcase if self.short_name.blank?
    end
end
