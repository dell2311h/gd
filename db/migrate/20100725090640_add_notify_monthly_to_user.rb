class AddNotifyMonthlyToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :notify_monthly, :boolean, :default => false
  end

  def self.down
    remove_column :users, :notify_monthly
  end
end
