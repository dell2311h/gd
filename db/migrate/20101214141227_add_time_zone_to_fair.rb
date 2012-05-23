class AddTimeZoneToFair < ActiveRecord::Migration
  def self.up
    add_column :fairs, :timezone, :string, :default => nil
  end

  def self.down
    remove_column :fairs, :timezone
  end
end
