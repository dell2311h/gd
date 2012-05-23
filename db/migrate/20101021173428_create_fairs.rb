class CreateFairs < ActiveRecord::Migration
  def self.up
    create_table :fairs do |t|
      t.string      :name
      t.date        :start_date
      t.date        :end_date
      t.string      :start_time    
      t.string      :end_time
      t.text        :description
      t.belongs_to  :fair_grouping
      
      t.string      :address
      t.belongs_to  :neighbourhood
      t.belongs_to  :city 
      t.belongs_to  :region
      t.belongs_to  :country
    end
  end

  def self.down
    drop_table :fairs
  end
end
