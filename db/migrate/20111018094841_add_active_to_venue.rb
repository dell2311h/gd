class AddActiveToVenue < ActiveRecord::Migration
  def self.up
  	add_column 'venues', 'active', :boolean, :default => false, :null => false
  end

  def self.down
  	remove_column 'venues', 'active'
  end
end
