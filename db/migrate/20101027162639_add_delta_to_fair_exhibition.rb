class AddDeltaToFairExhibition < ActiveRecord::Migration
  def self.up
    add_column :fair_exhibitions, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :fair_exhibitions, :delta
  end
end
