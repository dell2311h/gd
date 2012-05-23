# == Schema Information
# Schema version: 20110305012109
#
# Table name: notes
#
#  id           :integer(4)      not null, primary key
#  author_id    :integer(4)      not null
#  author_type  :string(30)      not null
#  subject_id   :integer(4)      not null
#  subject_type :string(30)      not null
#  text         :string(2048)    not null
#  created_at   :datetime
#  updated_at   :datetime
#

class Note < ActiveRecord::Base
  belongs_to :subject, :polymorphic => true
  belongs_to :author, :polymorphic => true

  validates_presence_of :text
end
