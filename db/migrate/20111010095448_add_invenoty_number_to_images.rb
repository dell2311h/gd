class AddInvenotyNumberToImages < ActiveRecord::Migration
  def self.up
  	add_column :images, 'inventory_number', :string, :limit => 15, :default => nil
  end

  def self.down
  	remove_column :images, 'inventory_number'
  end
end
