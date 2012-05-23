class AddDeltaToArtists < ActiveRecord::Migration
  def self.up
    add_column :artists, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :artists, :delta
  end
end
