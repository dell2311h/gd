class CreateFavoriteItineraries < ActiveRecord::Migration
  def self.up
    create_table :favorite_itineraries do |t|
      t.column :favorite_id, :integer, :null => false
      t.column :itinerary_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :favorite_itineraries
  end
end
