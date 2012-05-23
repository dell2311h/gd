class AddLatAndLngToVenue < ActiveRecord::Migration
  def self.up
    add_column :users, :lat, :string
    add_column :users, :lng, :string
  end

  def self.down
    remove_column :users, :lat
    remove_column :users, :lng
  end
end
