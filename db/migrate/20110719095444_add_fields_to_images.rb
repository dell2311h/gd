class AddFieldsToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :unit, :string
    add_column :images, :height, :integer
    add_column :images, :width, :integer
    add_column :images, :depth, :integer
  end

  def self.down
    remove_column :images, :unit
    remove_column :images, :height
    remove_column :images, :width
    remove_column :images, :depth
  end
end
