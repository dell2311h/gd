class Image < ActiveRecord::Base
  KINDS = {
            :logo => 'logo', 
            :default => 'default',
            :publication_pdf => 'publication_pdf',
            :attachment_art => 'attachment_art',
            :attachment_installation => 'attachment_installation',
            :attachment_reception => 'attachment_reception',
            :attachment_other => 'attachment_other'
          }
  
  UNITS = {
            :in => 'in',
            :cm => 'cm'
          }
  
  before_destroy :destroy_validate

  belongs_to :venue
  has_many :image_relations, :dependent => :destroy do
    def can_delete?
      self.where('owner_id is not null').size == 0 
    end
  end

  has_many :exhibitions, :through => :image_relations, :conditions => "`image_relations`.`owner_type` = 'Exhibition'"
  has_many :events, :through => :image_relations, :conditions => "`image_relations`.`owner_type` = 'Event'"
  
  has_attached_file :file, :styles => {:micro => "30x30>", :smaller => "40x40>", :small => "125x125>", :small_149 => '149x149#', :medium =>  "210x210>", :large => "300x300>" }, :whiny => false
  
  validates_attachment_presence :file
  validates_attachment_content_type :file, :content_type => ["image/jpeg", "image/png", "image/gif"], :allow_nil => true, :if => Proc.new {|i| i.kind != Image::KINDS[:publication_pdf] }
  validates_attachment_content_type :file, :content_type => ["application/pdf"], :allow_nil => true, :if => Proc.new {|i| i.kind == Image::KINDS[:publication_pdf] }
  
  validates_presence_of :artist, :if => Proc.new {|i| i.kind == Image::KINDS[:attachment_art] }, :message => 'Artist must be selected'
  validates_presence_of :exhibition_id, :if => Proc.new {|i| i.kind == Image::KINDS[:attachment_installation] }, :message => 'Exhibition must be selected'
  validates_presence_of :event_id, :if => Proc.new {|i| i.kind == Image::KINDS[:attachment_reception] }, :message => 'Event/reception must be selected'
  validates_presence_of :title, :if => Proc.new {|i| i.kind == Image::KINDS[:publication_pdf] }, :message => 'Title must be set'
  validates_presence_of :release_date, :if => Proc.new {|i| i.kind == Image::KINDS[:publication_pdf] }, :message => 'Release date must be selected'
  
  #  Only for image type attachment_art
  validates_length_of :inventory_number, :maximum => 15

  define_index do
    indexes :file_file_name, :sortable => true
    indexes :kind, :sortable => true
    indexes :artist, :sortable => true
    indexes :title, :sortable => true
    indexes :year, :sortable => true
    
    indexes exhibition.name, :as => :exhibition, :sortable => true 
    indexes event.title, :as => :exhibition, :sortable => true
    
    has :venue_id
    
    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  def kind_name
    kind = "image"
    kind = "pdf" if self.kind_pdf?
    kind
  end

  def kind_pdf?
    self.kind == Image::KINDS[:publication_pdf] rescue false
  end

  def allow_kinds
    if self.kind_pdf?
      "pdf only" 
    else
      "png, jpg, gif, no transparent"
    end
  end

  def image_url_for(sym)
    if self.kind_pdf?
      "/images/icons/pdf_#{sym.to_s}.png"
    else
      file.url(sym)
    end
  end
  
  def urls_object
    { :micro_url => file.url(:micro), :smaller_url => file.url(:smaller), :small_url => file.url(:small), :medium_url => file.url(:medium), :large_url => file.url(:large), :original_url => file.url }
  end
  
  def exhibition_id=(id)
    @_exhibition_id = id
    if self.new_record?
      self.image_relations << ImageRelation.new(:owner_id => id, :owner_type => 'Exhibition')
    end
  end
  
  def exhibition_id
    self.image_relations.where(:owner_type => 'Exhibition').first.id rescue @_exhibition_id
  end
  
  def event_id=(id)
    @_event_id = id
    if self.new_record?
      self.image_relations << ImageRelation.new(:owner_id => id, :owner_type => 'Event')
    end
  end
  
  def event_id
    self.image_relations.where(:owner_type => 'Event').first.id rescue @_event_id
  end

  def popup_caption
    arr = []
    %w('artists title date credit dimensions description medium').map do |attrname| 
      arr << "#{attrname}: #{self[attrname]}" unless self[attrname].blank?
    end
    arr.join(' | ')
  end

private

  def destroy_validate
    self.errors.add :base, "Cannot delete this image. Image is used." unless self.image_relations.can_delete?
    self.errors.empty?
  rescue
    false
  end
    
end
