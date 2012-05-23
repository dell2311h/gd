class CreateFairEvents < ActiveRecord::Migration
  def self.up
    create_table :fair_events do |t|
      t.belongs_to  :fair
      t.date        :event_date
      t.string      :start_time
      t.string      :end_time
      t.string      :name
      t.text        :description
      t.boolean     :on_site, :default => true
      t.string      :room
      t.integer     :fee, :default => 0
      
      t.string      :address
      t.string      :address2
      t.belongs_to  :city
      t.belongs_to  :region
      t.belongs_to  :country
      t.string      :zip
      
      t.timestamps
    end
  end

  def self.down
    drop_table :fair_events
  end
end
