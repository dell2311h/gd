class AddIsDefaulsToImages < ActiveRecord::Migration
  def self.up
  	add_column :images, 'is_default', :boolean, :default => false
  end

  def self.down
  	remove_column :images, 'is_default'
  end
end
