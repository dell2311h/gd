class FixPassFieldsForUser < ActiveRecord::Migration
  def self.up
    change_column :users, :salt, :string, :limit => nil
    change_column :users, :crypted_password, :string, :limit => nil
  end

  def self.down
    change_column :users, :salt, :string, :limit => 60
    change_column :users, :crypted_password, :string, :limit => 60
  end
end
