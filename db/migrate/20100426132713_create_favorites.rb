class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.belongs_to :user
      t.belongs_to :itinerary
      t.integer    :favorite_id
      t.string     :title
      t.text       :note
      t.timestamps
    end
  end

  def self.down
    drop_table :favorites
  end
end
