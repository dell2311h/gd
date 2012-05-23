class Venue < ActiveRecord::Base
    VENUE_TYPES = { 'museum' => 'museum', 'non-profit gallery' => 'non_profit', 'commercial gallery' => 'for_profit', 'alternative space' => 'alternative_space' }
    
    VENUE_COUNTRIES = ["ARG", "AUS", "AUT", "BHR", "BEL", "BGR", "CAN", "CHN", "CRI", "COL", "CUB", "CZE", "DNK", "EGY", "EST", "FIN", "FRA", "DEU", "GRC", "GBR", "HTI", "HUN", "ISL", "IND", "IRL", "ISR", "ITA", "JPN", "JOR", "KOR", "KWT", "LVA", "LBN", "LTU", "MEX", "MAR", "NLD", "NZL", "NOR", "PAK", "PAN", "PHL", "POL", "PRT", "PRI", "QAT", "ROU", "RUS", "SVK", "ZAF", "ESP", "SWE", "CHE", "TWN", "THA", "TUR", "UKR", "ARE", "USA", "VEN", "VNM"]
    
    # authlogic
    def to_key
      new_record? ? nil : [ self.send(self.class.primary_key) ]
    end
    
    acts_as_authentic do |c|
        c.transition_from_restful_authentication = true
        c.login_field = :email
    end
    # authlogic
    
    before_save :update_media_contact
    
    # location
    belongs_to :country
    belongs_to :region
    belongs_to :city
    belongs_to :neighbourhood
    # location
    
    # image manager compatibility
    has_many  :image_relations, :as => :owner
    has_many  :images, :through => :image_relations do
      def image
       first(:conditions => {:kind => Image::KINDS[:default]})
      end
    	def logo
    	 first(:conditions => {:kind => Image::KINDS[:logo]})
    	end
    end
    has_many  :related_images, :class_name => 'Image'
    # image manager compatibility
    
    #TODO remove after moved to new image manager
    has_attached_file :image, :styles => {:small => "125x125", :medium => "210x210", :large => "300x300" }
    has_attached_file :logo, :styles => {:small => "125x125", :medium => "210x210", :large => "300x300" }
    # end
    
    has_one   :listing_agent, :dependent => :destroy
    has_many  :media_service_setups, :dependent => :destroy
    has_many  :paypal_payments, :class_name => 'PayPalPayment', :foreign_key => 'user_id'
    has_many  :events, :dependent => :destroy
    has_many :artists, :dependent => :destroy
    has_many :curators, :dependent => :destroy
    has_many :exhibitions do
      def current_and_upcoming
        self.find(:all, :conditions => ['end >= ? AND enabled=1', Time.now ])
      end
      
      def current
        self.find(:all, :conditions => ['start < ? AND end >= ? AND enabled=1', Time.now, Time.now ])
      end
      
      def upcoming
        self.find(:all, :conditions => ['start > ? AND end >= ? AND enabled=1', Time.now, Time.now ])
      end
      
      def all_current_and_upcoming
        self.find(:all, :conditions => ['end >= ?', Time.now ])
      end
      def draft_current_and_upcoming
        self.find(:all, :conditions => ['end >= ? AND enabled<>1', Time.now ])
      end
      
      def expiring_in_ten_days
        self.find(:all, :conditions => ['end = ? AND enabled=1', 10.days.from_now.strftime("%Y-%m-%d") ])
      end
    end
    has_one  :venue_timetable, :dependent => :destroy
    has_many :favorited, :class_name => 'Favorite', :foreign_key => 'favorite_id', :dependent => :destroy
    
    has_many :fair_exhibitions, :dependent => :destroy
    has_many :fairs, :through => :fair_exhibitions
    
    # ==> temporarily disabled for new venue registration
    # validates :country_id, :region_id, :presence => true

    validates :neighbourhood_id, :city_name, :address, 
      :presence => true, 
      :on => :update, 
      :if => Proc.new { |i| i.confirmed }
    validates :postalcode, 
      :presence => true, 
      :numericality => true,
      :on => :update,
      :if => Proc.new { |i| i.confirmed }
    validates :contact_email,
      :length => { :minimum => 6, :maximum => 100 },
      :presence => true,
      :format => { :with => Authentication.email_regex },
      :on => :update,
      :if => Proc.new { |i| i.confirmed }

    validates_presence_of     :name
    validates_length_of       :description, :in => 0...3000
    validates_length_of       :transit, :in => 0...200
  	validates_associated      :venue_timetable, :message => %(needs to be filled completely), :allow_nil => true
    validates_inclusion_of    :authorized_representative, :in => ['1'], :on => :create, :message => 'must be checked'
    attr_accessor             :authorized_representative
    attr_accessible           :authorized_representative
    
    attr_accessible :login, :email, :password, :password_confirmation, :openid_identifier    
    
    attr_accessible           :name, :address, :address2, :transit, :country_id, :postalcode, :url, :phone, :contact_email,
                              :neighbourhood_id, :region_id, :city_id, :description, :password, :password_confirmation, :email,
                              :default_image_id, :logo_image_id, :image_ids, :confirmed
    
    attr_accessor             :image_upload, :skip_desc_validation, :skip_default_email
    
    @skip_desc_validation = false
    @skip_default_email = false
    @image_upload = false
    
    
    acts_as_mappable :default_units => :miles, 
                     :default_formula => :sphere, 
                     :distance_field_name => :distance,
                     :lat_column_name => :lat,
                     :lng_column_name => :lng

    @neighbourhood_name = ''
    
    def self.current
      @current_user || nil
    end

    def self.current=(current_venue)
      @current_user = current_venue      
    end

    def neighbourhood_name
      self.neighbourhood.name rescue @neighbourhood_name
    end

    def neighbourhood_name=(neighbourhood_name)
      @neighbourhood_name = neighbourhood_name
      self.neighbourhood = Neighbourhood.find_by_name(@neighbourhood_name, :conditions => ['city_id = ?', self.city_id])
      if self.neighbourhood.nil?
        self.neighbourhood = Neighbourhood.create(:name => @neighbourhood_name, :city_id => self.city_id) unless self.country_id.nil? or self.region_id.nil? or self.city_id.nil?
      end
    end
    
    def image_ids=(ids = nil)
      ids.delete_if {|i| i.blank? }
      unless ids.nil?
        self.image_relations.delete_all
        ids.each do |id|
          self.image_relations << ImageRelation.new(:image_id => id)
        end
      end
    end

    def image_ids
      self.image_relations.find(:all).map(&:image_id)
    end
    
    def default_image_id; self.images.image.id rescue nil; end
    
    def logo_image_id; self.images.logo.id rescue nil; end
    
    def gallery_type_text
      Venue::VENUE_TYPES.select {|t| self.gallery_type == t[1]}.first[0] rescue ''
    end

    #  Return true if gallery_type is museum
    def gallery_type_museum?
      self.gallery_type == VENUE_TYPES['museum'] rescue false
    end 

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
    
    def region_name
        self.region.name rescue ''
    end

    def region_code
      self.region.code rescue ''
    end

    def gmap_object
      address = [
        self.address,
        (self.city.name rescue nil),
        (self.region.name rescue nil),
        (self.country.name rescue nil)].compact.join(', ')

      if (self.lat.nil? || self.lng.nil?) && !self.address.nil?
        geo_info = Geokit::Geocoders::MultiGeocoder.geocode(address)
        self.lat = geo_info.lat
        self.lng = geo_info.lng
        self.save_without_validation!
      end

      map = GMap.new("map_div_id")
      map.control_init(:large_map => true, :map_type => true)
      map.center_zoom_init([self.lat,self.lng], 14)
      marker = GMarker.new([self.lat,self.lng], :title => self.name, :info_window => address)
      map.overlay_init(marker)
      map
    end

    #  Return url for google staticmap
    def gmap_staticmap_url(options = {})
      options.symbolize_keys!
      nearby = options[:nearby] || false

      url = "http://maps.googleapis.com/maps/api/staticmap?sensor=false&center=#{self.gmap_location}"
      url << "&size=245x185"
      url << "&markers=size:mid|color:red|label:V|#{self.gmap_location}"
  
      if nearby == true
        cnt = 1
        self.get_nearby_venues.map do |e|
          url << "&markers=size:mid|color:blue|label:#{cnt+=1}|#{e.gmap_location}"
        end
      end
      url << "&sensor=false"      
    end

    #  Return url to google maps full view
    def get_googlemap_url
      url = "http://maps.google.com/maps?q=#{self.gmap_location}&"
    end

    #  Return all nearby venues by neighbourhood
    def get_nearby_venues
      Venue.where(["neighbourhood_id = ? and id <> ?", self.neighbourhood_id, self.id])
    end        

    def full_address
      address = []
      #address << self.neighbourhood.name
      address << self.address
      #address << self.address2 unless self.address2.blank?
      address << self.city_name
      address << self.region_code
      address << self.postalcode
      address << self.country.name
      address.compact.join(' ')
    end
    
    def location
      [(self.neighbourhood.name rescue nil), (self.city_name rescue nil), (self.region_code rescue nil)].compact.join(', ')
    end
    
    def short_location
      ar = [self.city_name, self.region_code]
      res = ar.reject {|i| i.blank? }.join(', ')
      res << "<br/>#{self.country.name}" unless self.country.nil?
      res
    end
    
    def ultra_short_location
      ar = [(self.city.name rescue nil), (self.region.code rescue nil), (self.country.name rescue nil)]
      res = ar.compact.join(', ')
      res
    end

    def image_geometry(style = :original)
      @geometry ||= {}
      @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
    end
    
    def show_listing_agent
      self.listing_agent_enabled && self.listing_agent_end_date > Time.now
    end
    
    #def description=(s)
    #  write_attribute(:description, s.gsub(/(<style>.*<\/style>)/,'') )
    #end

  def confirmed!
    @_confirmed = false
    self.confirmed = true
    save
  end

  def confirmed
    @_confirmed == false ? @_confirmed : self[:confirmed]
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    VenueNotifier.deliver_activation_instructions(self)
  end

  def deliver_welcome!
    reset_perishable_token!
    VenueNotifier.deliver_welcome(self)
  end

  def timetable?
    self.venue_timetable.schedule.any?
  end

  def sendmail!(mail)
    VenueNotifier.deliver_venue(self,mail) if mail.valid?
  end

  #  Return gmap locations for venue
  def gmap_location
     # URI.escape([self.address,self.address2,self.city_name,self.region_code,self.postalcode,self.country.name].compact.join(' '))
    [self.address,self.region_name,self.postalcode].compact.join(' ')
  end

protected

  # def custom_validation
  #   self.errors.add :base, 'Image can''t be blank' if self.confirmed && self.images.image.nil?
  # end

private
  
  def update_media_contact
    self.media_contact_email = self.contact_email if self.media_contact_email.blank?
    self.media_contact = self.name if self.media_contact.blank?
  end
end
