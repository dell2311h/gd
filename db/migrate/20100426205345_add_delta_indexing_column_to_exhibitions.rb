class AddDeltaIndexingColumnToExhibitions < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :exhibitions, :delta
  end
end
