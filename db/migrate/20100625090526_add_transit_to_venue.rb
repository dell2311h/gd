class AddTransitToVenue < ActiveRecord::Migration
  def self.up
    add_column :users, :transit, :string, :default => ''
  end

  def self.down
    remove_column :users, :transit
  end
end
