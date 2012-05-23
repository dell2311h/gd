class AddDeltaToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :delta, :integer, :default => 0
  end

  def self.down
    remove_column :events, :delta, :integer
  end
end
