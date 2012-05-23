#TODO remove after moved to new image manager
class ExhibitionAttachment < ActiveRecord::Base
  has_attached_file :attachment, :styles => {:small => "125x125", :medium =>  "210x210", :large => "300x300" }
  validates_attachment_presence :attachment
  belongs_to  :exhibition
end
