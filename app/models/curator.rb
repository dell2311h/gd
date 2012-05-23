# == Schema Information
# Schema version: 20110213115125
#
# Table name: curators
#
#  id         :integer(4)      not null, primary key
#  venue_id   :integer(4)
#  first_name :string(255)
#  last_name  :string(255)
#  title      :string(255)
#  delta      :boolean(1)      default(TRUE)
#

class Curator < ActiveRecord::Base
  belongs_to :venue
  has_many :exhibition_curators do
    def can_delete?; self.size == 0 end
  end
  has_many :exhibitions, :through => :exhibition_curators

  before_destroy :destroy_validate
  
  validates_presence_of :last_name

  scope :sort_by_name, order('last_name, first_name')

  define_index do
    has :first_name, :sortable => true
    has :last_name, :sortable => true
    has :title
    has :venue_id
    
    indexes [:first_name, :last_name, :title], :as => :curator
    
    set_property :delta => true
    set_property :min_infix_len => 1
  end
  
  def full_name
    [self.first_name, self.last_name, ',', self.title]
  end

  def styled_full_name
    [last_name, first_name].select{|np| !np.blank? }.join(', ')
  end

  def full_name_last_first
    [last_name, first_name].compact.join(', ')
  end

protected
  
  def destroy_validate
    self.errors.add :base, "Cannot delete this curator. Curator is used." unless self.exhibition_curators.can_delete?
    self.errors.empty?
  rescue
    false
  end
    
end
