class RenameActiveToIsActiveInVenues < ActiveRecord::Migration
  def self.up
    rename_column :venues, :active, :is_active
  end

  def self.down
    rename_column :venues, :is_active, :active
  end
end
