# == Schema Information
# Schema version: 20110213115125
#
# Table name: fair_attachments
#
#  id                 :integer(4)      not null, primary key
#  fair_exhibition_id :integer(4)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer(4)
#  image_updated_at   :datetime
#  artist             :string(255)
#  title              :string(255)
#  year               :string(255)
#  credit             :string(255)
#

class FairAttachment < ActiveRecord::Base
  belongs_to  :fair_exhibition
  has_attached_file :image, :styles => { :small => "125x125", :bigger => "175x175", :medium =>  "210x210", :large => "300x300", :full => "800x800>" }
  validates_attachment_presence :image
  
  def caption
    [self.title, self.artist, self.credit, self.year].compact.join(', ')
  end
end
