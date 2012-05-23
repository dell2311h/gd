class CreateFairGroupings < ActiveRecord::Migration
  def self.up
    create_table :fair_groupings do |t|
      t.string    :name
      t.date      :start_date
      t.date      :end_date
    end
  end

  def self.down
    drop_table :fair_groupings
  end
end
