# == Schema Information
# Schema version: 20110213115125
#
# Table name: exhibition_tags
#
#  tag_id        :integer(4)
#  exhibition_id :integer(4)
#

class ExhibitionTag < ActiveRecord::Base
  belongs_to  :exhibition
  belongs_to  :tag
end
