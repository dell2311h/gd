class CreateExhibitionArtists < ActiveRecord::Migration
  def self.up
    create_table :exhibition_artists, :force => true do |t|
      t.column :exhibition_id, :integer, :null => false
      t.column :artist_id, :integer, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :exhibition_artists
  end
end
