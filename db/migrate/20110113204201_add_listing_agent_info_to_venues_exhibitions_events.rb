class AddListingAgentInfoToVenuesExhibitionsEvents < ActiveRecord::Migration
  def self.up
    add_column  :users, :boilerplate_info, :text, :default => ''
    
    add_column  :exhibitions, :curator, :text
    add_column  :exhibitions, :media_contact, :text
    add_column  :exhibitions, :associated_publication, :text
    add_column  :exhibitions, :associated_publication_url, :text
    add_column  :exhibitions, :short_description, :text
    add_column  :exhibitions, :listing_agent_enabled, :boolean, :default => false
    add_column  :exhibitions, :listing_agent_started_at, :datetime
    add_column  :exhibitions, :listing_agent_finished_at, :datetime
    add_column  :exhibitions, :listing_agent_completed, :boolean, :default => false
    
    add_column  :events, :curator, :text
    add_column  :events, :media_contact, :text
    add_column  :events, :associated_publication, :text
    add_column  :events, :associated_publication_url, :text
    add_column  :events, :short_description, :text
    add_column  :events, :listing_agent_enabled, :boolean, :default => false
    add_column  :events, :listing_agent_started_at, :datetime
    add_column  :events, :listing_agent_finished_at, :datetime
    add_column  :events, :listing_agent_completed, :boolean, :default => false
  end

  def self.down
    remove_column  :users, :boilerplate_info
    
    remove_column  :exhibitions, :curator
    remove_column  :exhibitions, :media_contact
    remove_column  :exhibitions, :associated_publication
    remove_column  :exhibitions, :associated_publication_url
    remove_column  :exhibitions, :short_description
    remove_column  :exhibitions, :listing_agent_enabled
    remove_column  :exhibitions, :listing_agent_started_at
    remove_column  :exhibitions, :listing_agent_finished_at
    remove_column  :exhibitions, :listing_agent_completed
    
    remove_column  :events, :curator
    remove_column  :events, :media_contact
    remove_column  :events, :associated_publication
    remove_column  :events, :associated_publication_url
    remove_column  :events, :short_description
    remove_column  :events, :listing_agent_enabled
    remove_column  :events, :listing_agent_started_at
    remove_column  :events, :listing_agent_finished_at
    remove_column  :events, :listing_agent_completed
  end
end
