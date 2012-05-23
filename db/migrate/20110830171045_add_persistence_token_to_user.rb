class AddPersistenceTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :persistence_token, :string, :default => nil
  end

  def self.down
    remove_column :users, :persistence_token
  end
end
