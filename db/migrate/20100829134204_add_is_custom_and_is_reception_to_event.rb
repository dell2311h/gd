class AddIsCustomAndIsReceptionToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :is_custom, :boolean, :default => false
    add_column :events, :is_reception, :boolean, :default => false
  end

  def self.down
    remove_column :events, :is_custom
    remove_column :events, :is_reception
  end
end
