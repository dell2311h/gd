class Agent < User
  has_many :tasks, :class_name => 'AgentTask'
  has_many :task_notes, :as => :author, :class_name => 'Note'

  @validate_terms_agreed = false
end
