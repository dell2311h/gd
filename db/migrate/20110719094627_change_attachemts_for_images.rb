class ChangeAttachemtsForImages < ActiveRecord::Migration
  def self.up
    #add_column :images, :delta, :boolean, :default => false
    Image.where(:kind => 'attachment').each do |image|
      image.kind = Image::KINDS[:attachment_other]
      image.save!
    end
  end

  def self.down
    Image.where(:kind => Image::KINDS[:attachment_other]).each do |image|
      image.kind = 'attachment'
      image.save!
    end
    #remove_column :images, :delta
  end
end
