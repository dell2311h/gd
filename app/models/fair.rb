# == Schema Information
# Schema version: 20110213115125
#
# Table name: fairs
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  start_date       :date
#  end_date         :date
#  start_time       :string(255)
#  end_time         :string(255)
#  description      :text
#  fair_grouping_id :integer(4)
#  address          :string(255)
#  neighbourhood_id :integer(4)
#  city_id          :integer(4)
#  region_id        :integer(4)
#  country_id       :integer(4)
#  delta            :boolean(1)      default(TRUE)
#  zip              :string(255)     default("")
#  location         :text
#  website          :string(255)     default("")
#  transportation   :text
#  lat              :string(255)
#  lon              :string(255)
#  timezone         :string(255)
#

require 'open-uri'
require 'geonames'

class Fair < ActiveRecord::Base
  belongs_to :fair_grouping
  belongs_to :neighbourhood
  belongs_to :city
  belongs_to :region
  belongs_to :country
  
  has_many :fair_exhibitions
  has_many  :fair_events
  
  #before_save :check_if_location_changed
  @location_changed = false
  
  define_index do
    indexes :name, :sortable => true
    # neighborhood, city or state
    indexes neighbourhood.name, :as => :neighborhood_name, :sortable => true
    indexes city.name, :as => :city_name, :sortable => true
    indexes region.name, :as => :region_name, :sortable => true
    indexes country.name, :as => :country_name, :sortable => true
    
    has :fair_grouping_id
    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  validates_presence_of :name
  
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :start_time
  validates_presence_of :end_time
  
    
  validates_presence_of :address
  validates_presence_of :zip
  validates_presence_of :neighbourhood
  validates_presence_of :city
  validates_presence_of :region
  validates_presence_of :country
  
  def venue_ids=(ids)
    ids.collect! {|i| i.to_i }
    if ids.kind_of?(Array)
      processed_ids = []
      self.fair_exhibitions.each do |fe|
        unless ids.include?(fe.venue_id)
          fe.destroy
        end
        processed_ids << fe.venue_id
      end
      new_ids = (ids - processed_ids)
      new_ids.each do |venue_id|
        fe = FairExhibition.new
        fe.venue_id = venue_id
        self.fair_exhibitions << fe unless venue_id.nil?
      end
    end
  end
  
  def venue_ids
    self.fair_exhibitions.collect {|fe| fe.venue_id }
  end
  
  def country_id
    self.city.region.country_id rescue @country_id
  end
  
  def country_id=(id)
    @country_id = id
    @location_changed = true
  end
  
  def region_id
    self.city.region_id rescue @region_id
  end
  
  def region_id=(id)
    @region_id = id
    @location_changed = true
  end
  
  def city_name
    self.city.name rescue ''
  end
  
  def city_name=(name)
    @location_changed = true
  end

  def neighbourhood_name
    self.neighbourhood.name rescue ''
  end

  def neighbourhood_name=(neighbourhood_name)
    @location_changed = true
  end
  
  def full_address
    address = []
    #address << self.neighbourhood.name
    address << self.address
    #address << self.address2 unless self.address2.blank?
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
  
  def location
    [self.neighbourhood.name, self.city_name, (self.region.code rescue '')].join(', ')
  end
  
  def short_location
    ar = [self.city_name, self.region.code]
    ar << self.country.name unless self.country.nil?
    ar.join(', ')
  end
  
  def website_url
    (!self.website.blank? && self.website =~ /(http|https):\/\//) ? self.website : "http://#{self.website}"
  end
  
  def timezone_string
    if self.timezone.nil? && !(self.lat.nil? || self.lon.nil?)
      tz = Geonames::WebService.timezone(self.lat, self.lon)
      self.timezone = ''
      self.timezone = ActiveSupport::TimeZone::MAPPING.index(tz.timezone_id) unless tz.nil?
      self.save_without_validation!
    end
    self.timezone
  end
  
  def localized_start_date
    Time.parse(self.start_date.to_s).in_time_zone(self.timezone)
  end
  
  def gmap_object
    address = [
      self.address,
      (self.city_name),
      (self.region.name rescue nil),
      self.country.name].compact.join(', ')

    if (self.lat.nil? || self.lon.nil?) && !address.blank?
      fetch_lat_lon
      self.save_without_validation!
    end

    map = GMap.new("map_div_id")
    map.control_init(:large_map => true, :map_type => true)
    map.center_zoom_init([self.lat,self.lon], 14)
    marker = GMarker.new([self.lat,self.lon], :title => "Where Am I?", :info_window => address)
    map.overlay_init(marker)
    map
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
  
  private
    def check_if_location_changed
      if @location_changed = true || (self.lat.nil? || self.lon.nil?)
        self.fetch_lat_lon
        @location_changed = false
      end
    end    
  
end
