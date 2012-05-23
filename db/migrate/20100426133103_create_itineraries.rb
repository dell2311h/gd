class CreateItineraries < ActiveRecord::Migration
  def self.up
    create_table :itineraries do |t|
      t.belongs_to  :user
      t.string      :title
      t.text        :note
      t.timestamps
    end
  end

  def self.down
    drop_table :itineraries
  end
end
