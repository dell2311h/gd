class AddFieldsToVenue < ActiveRecord::Migration
  def self.up
    add_column :users, :description, :text
    add_column :users, :url, :string, :limit => 200
  end

  def self.down
    remove_column :users, :description
    remove_column :users, :url
  end
end
