class AddLatLonToFair < ActiveRecord::Migration
  def self.up
    add_column :fairs, :lat, :string, :default => nil
    add_column :fairs, :lon, :string, :default => nil
  end

  def self.down
    remove_column :fairs, :lat
    remove_column :fairs, :lon
  end
end
