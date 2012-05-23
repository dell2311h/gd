class CreateExhibitionCurators < ActiveRecord::Migration
  def self.up
    create_table :exhibition_curators, :id => false do |t|
      t.belongs_to  :curator
      t.belongs_to  :exhibition
    end
  end

  def self.down
    drop_table :exhibition_curators
  end
end
