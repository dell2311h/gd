class ChangeDateColumnsInEvent < ActiveRecord::Migration
  def self.up
    change_column :events, :start_date, :date
    change_column :events, :end_date, :date
  end

  def self.down
    change_column :events, :start_date, :string
    change_column :events, :end_date, :string
  end
end
