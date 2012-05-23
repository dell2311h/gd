class Event < ActiveRecord::Base  
  # image manager compatibility
  has_many  :image_relations, :as => :owner
  has_many  :images, :through => :image_relations do
    def image
     first(:order => 'is_default desc, id desc', :conditions => {:kind => [Image::KINDS[:attachment_art], Image::KINDS[:attachment_installation], Image::KINDS[:attachment_reception], Image::KINDS[:attachment_other]]})
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
  # image manager compatibility
  
  belongs_to  :venue
  belongs_to  :exhibition
  belongs_to  :event_type
  
  has_many :agent_tasks, :foreign_key => 'target_id', :dependent => :destroy
  
  before_save :force_end_date_for_single_day_events
  after_save  :index_corresponding_full_event
  
  define_index do
    indexes :title, :sortable => true
    indexes venue.name, :as => :venue, :sortable => true
    # neighborhood, city or state
    indexes venue.neighbourhood.name, :as => :neighborhood, :sortable => true
    indexes venue.city.name, :as => :city, :sortable => true
    indexes venue.region.name, :as => :region, :sortable => true
    indexes venue.city.region_grouping.keywords, :as => :region_grouping_keywords, :sortable => false
    
    has :venue_id
    has venue.city_id, :as => :city_id, :facet => true
    has venue.neighbourhood_id, :as => :neighbourhood_id, :facet => true
    has venue.city.region_grouping(:id), :as => :region_grouping_id, :facet => true
    has :event_type_id
    has :start_date, :as => :open_date
    has :end_date, :as => :close_date
    has :updated_at
    has :enabled
    has event_type(:is_reception), :as => :is_reception
    where '`venues`.status = 1 and is_reception = 0' # and `venues`.login_count > 0' #Rejects exhibitions from not activated venues and events that marked as reception 

    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  validates_presence_of :venue
  validates_presence_of :event_type
  validates_presence_of :title
  
  validates_presence_of :start_date
  validates_presence_of :end_date, :if => Proc.new {|e| !e.single_day }
  validate :max_event_duration, :if => Proc.new {|e| !e.single_day }
  validates_presence_of :start_time
  validates_presence_of :cost, :if => Proc.new {|e| !e.free }
  validates_presence_of :short_description
  
  def event_type=(t)
    write_attribute(:event_type_id, t.id)
    self.event_type_name = t.name
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
  
  def days_left
    (self.end_date - Date.today)+1 #.days
  end
  
  def duration
    "#{self.start_date.strftime("%B %-1d")} - #{self.end_date.strftime("%B %-1d")}"
  end

  def normalized_title
    (self.title.blank?) ? ( (self.exhibition.nil?) ? ((self.event_type.is_custom) ? self.type_description.upcase : self.event_type.name.upcase) : self.exhibition.title ) : self.title
  end
  
  def title_with_type
    "#{ ((self.event_type.is_custom) ? self.type_description.upcase : self.event_type.name.upcase) }<br/><span style='font-size: 13px;'>#{self.title}</span>"
  end
  
  def event_image
    self.images.image ? self.images.image : ( (!self.exhibition.nil? && self.exhibition.images.image) ? self.exhibition.images.image : self.venue.images.image )
  end
  
  def formatted_event_date
    "#{self.start_date.strftime('%B %-1d, %Y ')}#{ (self.single_day) ? '' : self.end_date.strftime(' - %B %-1d, %Y') }"
  end
  
  def formatted_event_time
    "#{self.start_time.strftime('%I:%M %p').gsub(/^0/,'').downcase}#{ (self.end_time.nil?) ? '' : (' - ' + self.end_time.strftime('%I:%M %p').gsub(/^0/,'').downcase) }"
  end
  
  def formatted_reception_date(single_line = false)
    "#{self.start_date.strftime('%A, %B %-1d ')} #{ (self.single_day) ? '' : self.end_date.strftime('%A, %B %-1d ') } #{ (single_line) ? '' : '<br/>' }#{self.start_time.strftime('%I:%M %p').gsub(/^0/,'')}#{' - '+self.end_time.strftime('%I:%M %p').gsub(/^0/,'') unless self.end_time.nil?}"
  end
    
  def description=(s)
    write_attribute(:description, s.gsub(/(<style>.*<\/style>)/,'') )
  end

  #  Method for generation image path
  def image_path(size)
      (self.images.image) ? self.images.image.file.url(size) : ( (self.venue.images.image) ? self.venue.images.image.file.url(size) : "/images/noimage_#{(size == :large) ? 300 : ((size == :medium) ? 210 : 125)}.gif" )
  end

  def upcomin?
    self[:start_date] > Date.today
  end

  def sendmail!(mail)
    VenueNotifier.deliver_event(self,mail) if mail.valid?
  end

  #  Set default image for event, only one image can be default
  def set_default_image(default_image_id)
    #  without validation
    if self.images.any? && (default_image_id.to_i > 0)
      self.images.update_all(:is_default => 0) 
      self.images.update(default_image_id, :is_default => 1)
    end
  end


  protected
    def max_event_duration
      max_date = 14.days.since(start_date)
      errors.add(:end_date, "can't be in later then #{max_date.strftime('%m/%d/%Y')}") if end_date > max_date
    end
  
    def force_end_date_for_single_day_events
      self.end_date = self.start_date if self.single_day
    end
    
    def index_corresponding_full_event
      full = FullEvent.find(self.id)
      full.delta = true
      full.save
    end
      
end
