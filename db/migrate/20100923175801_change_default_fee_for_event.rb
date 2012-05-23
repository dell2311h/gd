class ChangeDefaultFeeForEvent < ActiveRecord::Migration
  def self.up
    change_column :events, :cost, :string, :default => ''
  end

  def self.down
    change_column :events, :cost, :float, :default => 0.0
  end
end
