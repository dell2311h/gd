# == Schema Information
# Schema version: 20110213115125
#
# Table name: exhibition_curators
#
#  curator_id    :integer(4)
#  exhibition_id :integer(4)
#

class ExhibitionCurator < ActiveRecord::Base
  belongs_to :exhibition
  belongs_to :curator
end
