class ChangeTimeColumnInPrograms < ActiveRecord::Migration
  def self.up
    change_column :programs, :start_time, :string
    change_column :programs, :end_time, :string
  end

  def self.down
    change_column :programs, :start_time, :datetime
    change_column :programs, :end_time, :datetime
  end
end
