class AddDeltaToFairEvents < ActiveRecord::Migration
  def self.up
    add_column :fair_events, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :fair_events, :delta
  end
end
