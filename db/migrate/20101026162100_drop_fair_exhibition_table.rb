class DropFairExhibitionTable < ActiveRecord::Migration
  def self.up
    drop_table "exhibitions_fairs"
  end

  def self.down
    create_table "exhibitions_fairs", :force => true, :id => false do |t|
      t.belongs_to :exhibition
      t.belongs_to :fair
    end
  end
end
