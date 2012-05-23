class Exhibition < ActiveRecord::Base
  # image manager compatibility
  has_many  :image_relations, :as => :owner
  has_many  :images, :through => :image_relations do
    def image
      first(:order => 'is_default desc, id desc', :conditions => {:kind => [Image::KINDS[:attachment_art], Image::KINDS[:attachment_installation], Image::KINDS[:attachment_reception]]})
    end
  	def publication_pdfs
  	 all(:conditions => {:kind => Image::KINDS[:publication_pdf]})
  	end
  	def attachments
  	 all(:conditions => {:kind => [Image::KINDS[:attachment_art], Image::KINDS[:attachment_installation], Image::KINDS[:attachment_reception], Image::KINDS[:attachment_other]]})
  	end
  	def art_attachments
  	 all(:conditions => {:kind => Image::KINDS[:attachment_art]})
  	end
  	def installation_attachments
  	 all(:conditions => {:kind => Image::KINDS[:attachment_installation]})
  	end
  	def reception_attachments
  	 all(:conditions => {:kind => Image::KINDS[:attachment_reception]})
  	end
  	def other_attachments
  	 all(:conditions => {:kind => Image::KINDS[:attachment_other]})
  	end
  	def all_attachments
  	 all(:conditions => "kind like 'attachment%'")
  	end
    def reception_installation_attachments
     all(:conditions => {:kind => [Image::KINDS[:attachment_installation], Image::KINDS[:attachment_reception]]})
    end
  end
  
  belongs_to :venue
  
  has_many  :events, :dependent => :destroy do
    def receptions
      find(:all, :conditions => { :event_type_name => 'Reception' } )
    end
  end
  
  has_many :exhibition_artists
  has_many :artists, :through => :exhibition_artists
  
  has_one :fair_exhibition
  
  has_many :exhibition_curators
  has_many :curators, :through => :exhibition_curators
  
  has_many :exhibition_tags
  has_many :tags, :through => :exhibition_tags, :limit => 5, :uniq => true
  
  belongs_to :medium
  
  has_many :agent_tasks, :foreign_key => 'target_id', :dependent => :destroy
  
  define_index do
    # venue, exhibition title, or artist
    indexes :title, :sortable => true
    indexes venue.name, :as => :venue, :sortable => true
    indexes [artists(:firstname), artists(:lastname)], :as => :artist
    # neighborhood, city or state
    indexes venue.neighbourhood.name, :as => :neighborhood, :sortable => true
    indexes venue.city.name, :as => :city, :sortable => true
    indexes venue.region.name, :as => :region, :sortable => true
    indexes venue.city.region_grouping.keywords, :as => :region_grouping_keywords, :sortable => false
    
    has :venue_id
    has venue.city_id, :as => :city_id, :facet => true
    has venue.neighbourhood_id, :as => :neighbourhood_id, :facet => true
    has venue.city.region_grouping(:id), :as => :region_grouping_id, :facet => true
    has :start, :as => :open_date
    has :end, :as => :close_date
    has :updated_at
    has :enabled
    where '`venues`.status = 1 and `exhibitions`.for_fair = 0' #Rejects exhibitions from not activated venues

    set_property :delta => true
    set_property :min_infix_len => 1
    set_property :group_concat_max_len => 8192
  end
  
  validates_presence_of :title
  validates_presence_of :artists, :message => 'needs to be selected'
  validates_presence_of :start
  validates_presence_of :end
  validates_presence_of :short_description
  validates_length_of   :description, :in => 0...5000
    
  def artist_ids=(ids = nil)
    self.artists.delete_all
    unless ids.nil?
      self.artists = Artist.find(ids)
    end
  end
  
  def artist_ids
    self.artists.find(:all).map(&:id)
  end
  
  def curator_ids=(ids = nil)
    self.curators.delete_all
    unless ids.nil?
      self.curators = Curator.find(ids)
    end
  end
  
  def curator_ids
    self.curators.find(:all).map(&:id)
  end
  
  def tag_ids=(ids = nil)
    ids.delete_if {|i| i.blank? }
    unless ids.nil?
      self.tags.delete_all
      self.tags = Tag.find(ids.compact)
    end
  end
  
  def tag_ids
    self.tags.find(:all).map(&:id)
  end
  
  def image_ids=(ids = nil)
    unless ids.nil?
      ids.delete_if {|i| i.blank? }
      self.image_relations.delete_all
      ids.each do |id|
        self.image_relations << ImageRelation.new(:image_id => id)
      end
    end
  end
  
  def image_ids
    self.image_relations.find(:all).map(&:image_id)
  end
  
  def set_public_reception(event, params = nil)
    unless event.start_date.blank?
      event.title ||= self.title + ' Reception'
      event.exhibition = self
      event.venue = event.exhibition.venue
      event.event_type = EventType.where(:name => 'Reception').first
      event.short_description = event.title
      event.enabled = self.enabled
      event.update_attributes(params) unless params.nil?
      event.save
      # TODO: add errors to reception_date
      require 'pp'
      pp event
      pp event.errors
      return event.valid?
    end
    return true
  end
  
  def duration
    "#{self.start.strftime("%B %-1d")} - #{self.end.strftime("%B %-1d")}"
  end

	def days_left
    (self.end - Date.today)+1 #.days
	end

  def open_at?(date)
    (date >= self.start) && (date <= self.end)
  end

  def formatted_public_reception_date(single_line = false)
    if self.events.receptions.first
      # #{' - '+self.events.receptions.first.end_time.strftime('%I:%M %p').gsub(/^0/,'') unless self.events.receptions.first.end_time.nil?}
      "#{self.events.receptions.first.start_date.strftime('%A, %B %-1d ')}#{ (single_line) ? ' - ' : '<br/>' }#{self.events.receptions.first.start_time.strftime('%I:%M %p').gsub(/^0/,'')}"
    else
     false
    end
  end

  def artist_names
    artists.compact.sort_by(&:lastname).map { |a| a.full_name }
  end

  def curator_names
    curators.compact.sort_by(&:last_name).map { |c| c.styled_full_name }
  end
  
  def description=(s)
    write_attribute(:description, s.gsub(/(<style>.*<\/style>)/,'') )
  end

  #  Method for generation image path
  def image_path(size)
      (self.images.image) ? self.images.image.file.url(size) : ( (self.venue.images.image) ? self.venue.images.image.file.url(size) : "/images/noimage_#{(size == :large) ? 300 : ((size == :medium) ? 210 : 125)}.gif" )
  end

  def upcomin?
    self[:start] > Date.today
  end

  def sendmail!(mail)
    VenueNotifier.deliver_exhibition(self,mail) if mail.valid?
  end

  #  Set default image for exhibition, only one image can be default
  def set_default_image(default_image_id)
    #  without validation
    if self.images.any? && (default_image_id.to_i > 0)
      self.images.update_all(:is_default => 0) 
      self.images.update(default_image_id, :is_default => 1)
    end
  end

protected

  def check_email(email)
    email =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end

end
