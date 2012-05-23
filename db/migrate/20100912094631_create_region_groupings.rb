class CreateRegionGroupings < ActiveRecord::Migration
  def self.up
    create_table :region_groupings do |t|
      t.string  :name
      t.text    :keywords
    end
  end

  def self.down
    drop_table :region_groupings
  end
end
