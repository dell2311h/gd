# == Schema Information
# Schema version: 20110213115125
#
# Table name: fair_events
#
#  id          :integer(4)      not null, primary key
#  fair_id     :integer(4)
#  event_date  :date
#  start_time  :string(255)
#  end_time    :string(255)
#  name        :string(255)
#  description :text
#  on_site     :boolean(1)      default(TRUE)
#  room        :string(255)
#  fee         :integer(4)      default(0)
#  address     :string(255)
#  address2    :string(255)
#  city_id     :integer(4)
#  region_id   :integer(4)
#  country_id  :integer(4)
#  zip         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  delta       :boolean(1)      default(TRUE)
#  lat         :string(255)
#  lon         :string(255)
#

class FairEvent < ActiveRecord::Base
  
  belongs_to  :fair
  belongs_to  :city
  belongs_to  :region
  belongs_to  :country
  
  define_index do
    indexes :name, :sortable => true
    indexes :description
    # neighborhood, city or state
    indexes city.name, :as => :city_name, :sortable => true
    indexes region.name, :as => :region_name, :sortable => true
    indexes country.name, :as => :country_name, :sortable => true
    
    has :fair_id
    has fair(:fair_grouping_id), :as => :fair_grouping_id
    has :event_date
    has :start_time
    set_property :delta => true
    set_property :min_infix_len => 1
  end
  validates_presence_of :event_date
  validates_presence_of :start_time
  validates_presence_of :name
  validates_presence_of :room
  
  validates_presence_of :address, :if => Proc.new {|e| !e.on_site }
  validates_presence_of :city_id, :if => Proc.new {|e| !e.on_site }
  validates_presence_of :region_id, :if => Proc.new {|e| !e.on_site }
  validates_presence_of :country_id, :if => Proc.new {|e| !e.on_site }
  validates_presence_of :zip, :if => Proc.new {|e| !e.on_site }
  
  def city_name
    self.city.name rescue ''
  end
  
  def city_name=(city_name)
    @city_name = city_name
    self.city = (self.region_id.nil?) ? City.find_by_name(@city_name) : City.find_by_name(@city_name, :conditions => { :region_id => self.region_id })
    if self.city.nil?
      unless self.country_id.nil? or self.region_id.nil?
        res = MultiGeocoder.geocode("#{@city_name}, #{self.region.name}, #{self.country.name}")
        self.city = City.create(:name => @city_name, :country_id => self.country_id, :region_id => self.region_id, :latitude => res.lat, :longitude => res.lng) if res.success
      end
    end
  end
  
  def short_location
    ar = [self.city.name, self.region.code]
    ar << self.country.name unless self.country.nil?
    ar.join(', ')
  end
  
  def full_address
    address = []
    address << self.address
    address << self.address2 unless self.address2.blank?
    address << self.city_name
    address << (self.city.region.code rescue '')
    address << self.zip
    address << self.country.name
    address.compact.join(', ')
  end
  
  def mobile_full_address
    address = []
    address << self.address
    address << [ (self.city.name rescue nil), (self.city.region.code rescue nil), (self.zip rescue nil) ].compact.join(', ')
    address.compact.join('<br/>')
  end
  
  def time_for_comparison
    Time.parse(self.event_date.strftime('%Y-%m-%d') + ' ' + self.start_time)
  end
  
  def localized_event_date
    t = Time.parse(self.event_date.to_s).in_time_zone(self.fair.timezone)
    Date.parse(t.strftime('%Y-%m-%d'))
  end
  
  def fetch_lat_lon
    address = [
      self.address,
      (self.city.name rescue nil),
      (self.region.name rescue nil),
      (self.country.name rescue nil)].compact.join(', ')
    geo_info = Geokit::Geocoders::MultiGeocoder.geocode(address)
    self.lat = geo_info.lat
    self.lon = geo_info.lng
  end
  
end
