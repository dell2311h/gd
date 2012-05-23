class CreateExhibitionTags < ActiveRecord::Migration
  def self.up
    create_table :exhibition_tags, :id => false do |t|
      t.belongs_to :tag
      t.belongs_to :exhibition
    end
  end

  def self.down
    drop_table :exhibition_tags
  end
end
