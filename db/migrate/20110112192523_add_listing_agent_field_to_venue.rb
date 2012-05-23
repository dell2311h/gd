class AddListingAgentFieldToVenue < ActiveRecord::Migration
  def self.up
    add_column :users, :listing_agent_enabled, :boolean, :default => false
    add_column :users, :listing_agent_end_date, :datetime
  end

  def self.down
    remove_column :users, :listing_agent_enabled
    remove_column :users, :listing_agent_end_date
  end
end
