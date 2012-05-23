class DropUnusedJoinTables < ActiveRecord::Migration
  def self.up
    drop_table 'fairs_venues'
  end

  def self.down
    create_table "fairs_venues", :force => true, :id => false do |t|
      t.belongs_to :venue
      t.belongs_to :fair
    end
  end
end
