class AddDeltaToFairGroupings < ActiveRecord::Migration
  def self.up
    add_column :fair_groupings, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :fair_groupings, :delta
  end
end
