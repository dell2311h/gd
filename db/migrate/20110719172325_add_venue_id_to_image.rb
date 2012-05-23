class AddVenueIdToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :venue_id, :integer
    add_column :images, :delta, :boolean, :default => false
    Image.all.each do |image|
      begin
        image.venue_id = ((image.image_relations.first.owner.is_a?(Venue)) ? image.image_relations.first.owner_id : image.image_relations.first.owner.venue_id)
        image.save!
      rescue

      end
      image.destroy if image.venue_id.nil?
    end
  end

  def self.down
    remove_column :images, :venue_id
  end
end
