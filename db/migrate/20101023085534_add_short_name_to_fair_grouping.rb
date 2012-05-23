class AddShortNameToFairGrouping < ActiveRecord::Migration
  def self.up
    add_column :fair_groupings, :short_name, :string, :default => ''
  end

  def self.down
    remove_column :fair_groupings, :short_name
  end
end
