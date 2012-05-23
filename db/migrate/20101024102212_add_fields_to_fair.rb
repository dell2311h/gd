class AddFieldsToFair < ActiveRecord::Migration
  def self.up
    add_column :fairs, :zip, :string, :default => ''
    add_column :fairs, :location, :text
    add_column :fairs, :website, :string, :default => ''
    add_column :fairs, :transportation, :text
  end

  def self.down
    remove_column :fairs, :zip
    remove_column :fairs, :location
    remove_column :fairs, :website
    remove_column :fairs, :transportation
  end
end
