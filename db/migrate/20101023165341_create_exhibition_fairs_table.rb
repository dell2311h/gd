class CreateExhibitionFairsTable < ActiveRecord::Migration
  def self.up
    create_table "exhibitions_fairs", :force => true, :id => false do |t|
      t.belongs_to :exhibition
      t.belongs_to :fair
    end
  end

  def self.down
    drop_table "exhibitions_fairs"
  end
end
