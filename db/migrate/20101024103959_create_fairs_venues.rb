class CreateFairsVenues < ActiveRecord::Migration
  def self.up
    create_table "fairs_venues", :force => true, :id => false do |t|
      t.belongs_to :venue
      t.belongs_to :fair
    end
  end

  def self.down
  end
end
