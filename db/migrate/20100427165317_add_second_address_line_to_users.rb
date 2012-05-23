class AddSecondAddressLineToUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :address2, :string, :limit => 255
  end

  def self.down
    remove_column :users, :address2
  end
end
