class RenameIsActiveToConfirmed < ActiveRecord::Migration
  def self.up
    rename_column :venues, :is_active, :confirmed
    Venue.update_all ['confirmed = ?',true]
  end

  def self.down
    rename_column :venues, :confirmed, :is_active
  end
end
