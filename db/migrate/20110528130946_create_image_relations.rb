class CreateImageRelations < ActiveRecord::Migration
  def self.up
    create_table :image_relations do |t|
      t.belongs_to :image
      t.integer    :owner_id
      t.string     :owner_type
    end
  end

  def self.down
    drop_table :image_relations
  end
end
