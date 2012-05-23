require 'pp'
class MoveAllVenueImagesToSeparateTable < ActiveRecord::Migration
  def self.up
    Venue.all.each do |venue|
      venue.images << Image.create(
                                    :file => venue.image,
                                    :kind => Image::KINDS[:default]
                                  ) if venue.image?
                                        
      venue.images << Image.create(:file => venue.logo, :kind => Image::KINDS[:logo]) if venue.logo?
      
      pp venue.name
    end
    remove_column :venues, :image_file_name
    remove_column :venues, :image_content_type
    remove_column :venues, :image_file_size
    remove_column :venues, :image_updated_at
  end

  def self.down
  end
end
