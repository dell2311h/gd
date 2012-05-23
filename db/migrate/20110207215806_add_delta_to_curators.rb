class AddDeltaToCurators < ActiveRecord::Migration
  def self.up
    add_column :curators, :delta, :boolean, :default => true
  end

  def self.down
    remove_column :curators, :delta
  end
end
