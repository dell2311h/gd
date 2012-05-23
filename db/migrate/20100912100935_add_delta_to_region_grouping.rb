class AddDeltaToRegionGrouping < ActiveRecord::Migration
  def self.up
    add_column :region_groupings, :delta, :integer, :default => 0
  end

  def self.down
    remove_column :region_groupings, :delta
  end
end
