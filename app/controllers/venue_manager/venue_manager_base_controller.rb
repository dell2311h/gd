class VenueManager::VenueManagerBaseController < ApplicationController
  before_filter :require_venue, :except => [:neighbourhood_autocomplete]
  layout Proc.new { (%w(new create edit update destroy).include?(self.action_name)) ? 'popup' : 'application' }
  
  protected
    def fetch_item_counts_for(items)
      items.each do |item, field|
        self.instance_variable_set("@#{item.to_s.pluralize}_count".to_sym, current_venue.send("#{item.to_s.pluralize}").count(:conditions => ["`#{item.to_s.pluralize}`.`#{field}` >= ?", Time.now]))
        # self.instance_variable_set("@past_#{item.to_s.pluralize}_count".to_sym, current_venue.send("#{item.to_s.pluralize}").count(:conditions => ["`#{item.to_s.pluralize}`.`#{field}` < ?", Time.now]))
      end
    end
    
end
