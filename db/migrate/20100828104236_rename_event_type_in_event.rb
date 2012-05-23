class RenameEventTypeInEvent < ActiveRecord::Migration
  def self.up
    rename_column :events, :event_type, :event_type_name
  end

  def self.down
    rename_column :events, :event_type_name, :event_type
  end
end
