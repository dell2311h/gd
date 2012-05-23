class ChangeTypeToEventTypInEvents < ActiveRecord::Migration
  def self.up
    rename_column :events, :type, :event_type
  end

  def self.down
    rename_column :events, :event_type, :type
  end
end
