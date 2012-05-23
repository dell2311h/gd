class AddLatLonToFairEvent < ActiveRecord::Migration
  def self.up
    add_column :fair_events, :lat, :string
    add_column :fair_events, :lon, :string
  end

  def self.down
    remove_column :fair_events, :lat
    remove_column :fair_events, :lon
  end
end
