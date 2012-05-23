class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.belongs_to  :venue
      t.belongs_to  :exhibition
      t.string      :title
      t.string      :type
      t.string      :series_name
      t.string      :start_date
      t.string      :end_date
      t.datetime    :start_time
      t.datetime    :end_time
      t.text        :description
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
