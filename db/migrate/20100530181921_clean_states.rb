class CleanStates < ActiveRecord::Migration
  def self.up
    execute "DELETE FROM regions WHERE name = 'WebTV' OR name = 'United States' OR name = 'AOL';"
  end

  def self.down
  end
end
