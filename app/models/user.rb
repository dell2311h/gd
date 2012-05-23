class User < ActiveRecord::Base
  include Geokit::Geocoders
  
  # authlogic
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  
  acts_as_authentic do |c|
    # c.transition_from_restful_authentication = true
    c.login_field = :email
  end
  # authlogic
  
  has_many  :favorites, :dependent => :destroy
  has_many  :itineraries, :dependent => :destroy

  belongs_to :country
  validates_presence_of :country_id, :if => Proc.new {|u| u.type != 'Admin' && u.type != 'Agent' }
  belongs_to :region
  validates_presence_of :region_id, :if => Proc.new {|u| u.type != 'Admin' && u.type != 'Agent' }
  belongs_to :city
  validates_presence_of :city_name, :if => Proc.new {|u| u.type != 'Admin' && u.type != 'Agent' }
  # location

  validates_presence_of     :firstname

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email

#  attr_accessible :email, :name, :password, :password_confirmation, :city_name, :lastname, :firstname,
#                  :address, :postalcode, :phone, :ipaddress, :birthdate, :gender,
#                  :country_id, :region_id, :city_id, :neighbourhood_id, :login_count, :gallery_type,
#                  :captcha_key, :captcha, :notify_monthly
  
                  
  def has_favorite?(vanue_or_venue_id)
    v_id = (vanue_or_venue_id.kind_of?(Venue)) ? vanue_or_venue_id.id : vanue_or_venue_id
    self.favorites.select {|f| f.favorite_id == v_id }.size > 0
  end
                  
  def full_name
    "#{firstname} #{lastname}"
  end
  
  @city_name = ''
  
  def city_name
    self.city.name rescue @city_name
  end
  
  def city_name=(city_name)
    @city_name = city_name
    self.city = City.find_by_name(@city_name)
    if self.city.nil?
      unless self.country_id.nil? or self.region_id.nil?
        res = MultiGeocoder.geocode("#{@city_name}, #{self.region.name}, #{self.country.name}")
        self.city = City.create(:name => @city_name, :country_id => self.country_id, :region_id => self.region_id, :latitude => res.lat, :longitude => res.lng) if res.success
      end
    end
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

end
