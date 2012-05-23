class CreateExhibitions < ActiveRecord::Migration
  def self.up
    create_table :exhibitions do |t|
        t.string    :title
        t.belongs_to    :venue
        t.text      :description
        t.boolean   :enabled
        t.date      :start
        t.date      :end
        t.timestamps
    end
  end

  def self.down
    drop_table :exhibitions
  end
end
