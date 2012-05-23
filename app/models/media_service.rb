# == Schema Information
# Schema version: 20110213115125
#
# Table name: media_services
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  editor      :string(255)
#  region      :string(255)
#  url         :string(255)
#  form_based  :boolean(1)      default(FALSE)
#  email       :string(255)
#  api_url     :string(255)
#  media_type  :string(255)
#  deadline    :datetime
#  edited      :boolean(1)      default(FALSE)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class MediaService < ActiveRecord::Base
  has_many :media_service_setups, :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :url
  validates_presence_of :email, :if => Proc.new {|ms| !ms.form_based? }
  validates_format_of   :email,
                        :with       => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                        :message    => 'must be valid',
                        :if => Proc.new {|ms| !ms.form_based? }
  validates_presence_of :api_url, :if => Proc.new {|ms| ms.form_based? }
  
  define_index do
    indexes :name, :sortable => true
    has :id
    
    set_property :delta => true
    set_property :min_infix_len => 1
    set_property :group_concat_max_len => 8192
  end
end
