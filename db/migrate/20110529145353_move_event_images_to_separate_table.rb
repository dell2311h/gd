require 'pp'
class MoveEventImagesToSeparateTable < ActiveRecord::Migration
  def self.up
    Event.all.each do |event|
      event.images << Image.create(
                                    :file => event.image,
                                    :kind => Image::KINDS[:default]
                                  ) if event.image?
      pp event.title
    end
    remove_column :events, :image_file_name
    remove_column :events, :image_content_type
    remove_column :events, :image_file_size
    remove_column :events, :image_updated_at
  end

  def self.down
  end
end
