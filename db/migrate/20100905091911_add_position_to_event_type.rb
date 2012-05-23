class AddPositionToEventType < ActiveRecord::Migration
  def self.up
    add_column :event_types, :pos, :integer, :default => 0
  end

  def self.down
    remove_column :event_types, :pos
  end
end
