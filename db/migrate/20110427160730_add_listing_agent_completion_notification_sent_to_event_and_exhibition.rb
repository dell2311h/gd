class AddListingAgentCompletionNotificationSentToEventAndExhibition < ActiveRecord::Migration
  def self.up
    add_column :events, :listing_agent_completion_notification_sent, :boolean, :default => false
    add_column :exhibitions, :listing_agent_completion_notification_sent, :boolean, :default => false
  end

  def self.down
    remove_column :events, :listing_agent_completion_notification_sent, :boolean, :default => false
    remove_column :exhibitions, :listing_agent_completion_notification_sent, :boolean, :default => false
  end
end
