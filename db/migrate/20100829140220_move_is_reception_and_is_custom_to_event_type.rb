class MoveIsReceptionAndIsCustomToEventType < ActiveRecord::Migration
  def self.up
    remove_column :events, :is_custom
    remove_column :events, :is_reception
    add_column :event_types, :is_custom, :boolean, :default => false
    add_column :event_types, :is_reception, :boolean, :default => false
  end

  def self.down
    remove_column :event_types, :is_custom
    remove_column :event_types, :is_reception
    add_column :events, :is_custom, :boolean, :default => false
    add_column :events, :is_reception, :boolean, :default => false
  end
end
