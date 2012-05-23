class AddDeltaToMediaServices < ActiveRecord::Migration
  def self.up
    add_column :media_services, :delta, :boolean, :default => false
  end

  def self.down
    remove_column :media_services, :delta
  end
end
