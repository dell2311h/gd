class ChangeEventFields < ActiveRecord::Migration
  def self.up
    remove_column :events, :series_name
    add_column :events, :type_description, :string
    add_column :events, :free, :boolean, :default => true
    add_column :events, :rsvp, :boolean, :default => true
  end

  def self.down
    add_column :events, :series_name, :string
    remove_column :events, :type_description, :string
    remove_column :events, :free, :boolean, :default => true
    remove_column :events, :rsvp, :boolean, :default => true
  end
end
