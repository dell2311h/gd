class AddEnabledToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :enabled, :boolean, :default => true
  end

  def self.down
    remove_column :events, :enabled
  end
end
