class AddDeltaToFair < ActiveRecord::Migration
  def self.up
    add_column :fairs, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :fairs, :delta
  end
end
