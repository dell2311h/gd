class RemovePrograms < ActiveRecord::Migration
  def self.up
    drop_table :programs
  end

  def self.down
  end
end
