class DeleteUserIncome < ActiveRecord::Migration
  def self.up
    remove_column :users, :income
  end

  def self.down
    add_column  :users, :income, :string, :limit => 80
  end
end
