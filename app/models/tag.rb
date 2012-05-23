# == Schema Information
# Schema version: 20110213115125
#
# Table name: tags
#
#  id   :integer(4)      not null, primary key
#  name :string(255)
#

class Tag < ActiveRecord::Base
  has_many :exhibitions
end
