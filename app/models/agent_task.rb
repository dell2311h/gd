# == Schema Information
# Schema version: 20110305012109
#
# Table name: agent_tasks
#
#  id               :integer(4)      not null, primary key
#  agent_id         :integer(4)
#  exhibition_id    :integer(4)      not null
#  media_service_id :integer(4)      not null
#  status           :string(20)
#  created_at       :datetime
#  updated_at       :datetime
#

class AgentTask < ActiveRecord::Base
  belongs_to :agent
  belongs_to :target, :polymorphic => true
  belongs_to :media_service
  has_many :notes, :as => :subject

  STATUSES = ['new', 'done', 'failed']

  validates_presence_of :target
  validates_presence_of :media_service
  validates_inclusion_of :status, :in => STATUSES, :if => :agent_id? #Care about status only for assigned tasks
  validates_length_of :notes, :minimum => 1, :if => :failed? #I guess a comment is required for failed task
  

  def done?
    status=='done'
  end

  def failed?
    status=='failed'
  end

  def to_s
    "#{target.title} @ #{target.venue.name} on #{media_service.name}"
  end
  
  def media_service_setup
    self.target.venue.media_service_setups.find(:first, :conditions => { :media_service_id => self.media_service_id } ) 
  end

end
