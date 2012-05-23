class AddRegionGroupingIdToCity < ActiveRecord::Migration
  def self.up
    add_column :cities, :region_grouping_id, :integer
  end

  def self.down
    remove_column :cities, :region_grouping_id
  end
end
