# == Schema Information
# Schema version: 20110213115125
#
# Table name: artists
#
#  id              :integer(4)      not null, primary key
#  firstname       :string(255)
#  lastname        :string(255)
#  middlename      :string(255)
#  birthdate       :date
#  deathdate       :date
#  representation  :text
#  url             :string(255)
#  photourl        :string(255)
#  biography       :text
#  enabled         :boolean(1)      default(FALSE)
#  nickname        :string(255)
#  national_origin :string(255)
#  venue_id        :integer(4)
#  created_at      :datetime
#  updated_at      :datetime
#  delta           :boolean(1)      default(TRUE)
#

class Artist < ActiveRecord::Base
  belongs_to :venue
  has_many :exhibition_artists do
    def can_delete?; self.size == 0 end
  end
  has_many :exhibitions, :through => :exhibition_artists

  before_destroy :destroy_validate
  
  define_index do
    has :firstname, :sortable => true
    has :lastname, :sortable => true
    has :middlename
    has :venue_id
    
    indexes [:firstname, :middlename, :lastname], :as => :artist
    
    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  cattr_reader :per_page
  @@per_page = 25
  
  validates_presence_of :lastname
  validates :death_year, :birth_year,
    :numericality => { :less_than_or_equal_to => Date.today.year },
    :length => { :is => 4 },
    :allow_nil => true

  validates :death_year, 
    :numericality => { :greater_than => :birth_year },
    :allow_nil => true

  scope :sort_by_name, order('lastname, firstname')

  def get_default_date_by_year(year)
    year.to_i == 0 ? year : Date.parse("01-01-#{year}")
  end
   
  #  Update the attribute birthdate with specified year
  def birth_year=(year)
    @_birth_year = year.blank? ? nil : year
    write_attribute :birthdate, get_default_date_by_year(year) if year
  end

  #  Get birth year
  def birth_year
    self.birthdate ? self.birthdate.year : @_birth_year
  end

  #  Update the attribute deathdate with specified year
  def death_year=(year)
    @_death_year = year.blank? ? nil : year
    write_attribute :deathdate, get_default_date_by_year(year) if year
  end
  
  #  Get death year
  def death_year
    self.deathdate ? self.deathdate.year : @_death_year
  end


  def birthyear
    self.birthdate ? self.birthdate.year : '-'
  end
  
  def full_born
    [self.born_in, self.born_in_country].reject {|s| s.blank? }.join(', ')
  end
  
  def full_lives
    [self.live_in, self.live_in_country].reject {|s| s.blank? }.join(', ')
  end

  def deathyear
    self.deathdate ? self.deathdate.year : '-'
  end


  def full_name
    [firstname, middlename, lastname].reject { |name_part| name_part.blank? }.join(' ').strip
  end
  
  def styled_full_name
    [lastname.strip, ([firstname.strip, middlename.strip].reject { |n| n.blank? }.join(' ')) ].reject { |name_part| name_part.blank? }.join(', ')
  end


  def full_name_last_first
    [lastname, firstname].compact.join(', ')
  end

protected

  def destroy_validate
    self.errors.add(:base, "Cannot delete this artist. Artist is used.") unless self.exhibition_artists.can_delete?
    self.errors.empty?
  rescue
    false
  end

end
