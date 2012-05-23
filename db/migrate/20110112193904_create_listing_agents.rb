class CreateListingAgents < ActiveRecord::Migration
  def self.up
    create_table :listing_agents do |t|
      t.belongs_to :venue
      t.datetime  :payment_date
      t.datetime  :valid_through
      t.string    :transaction_id
      t.integer   :total
      
      t.boolean   :exhibitions_enabled, :default => false
      t.boolean   :events_enabled, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :listing_agents
  end
end
