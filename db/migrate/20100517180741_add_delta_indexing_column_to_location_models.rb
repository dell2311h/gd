class AddDeltaIndexingColumnToLocationModels < ActiveRecord::Migration
  def self.up
    add_column :regions, :delta, :boolean, :default => true
    add_column :cities, :delta, :boolean, :default => true
    add_column :countries, :delta, :boolean, :default => true
    add_column :neighbourhoods, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :regions, :delta
    remove_column :cities, :delta
    remove_column :countries, :delta
    remove_column :neighbourhoods, :delta
  end
end
