# == Schema Information
# Schema version: 20110213115125
#
# Table name: listing_agents
#
#  id                  :integer(4)      not null, primary key
#  venue_id            :integer(4)
#  payment_date        :datetime
#  valid_through       :datetime
#  transaction_id      :string(255)
#  total               :integer(4)
#  exhibitions_enabled :boolean(1)      default(FALSE)
#  events_enabled      :boolean(1)      default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#

class ListingAgent < ActiveRecord::Base
  belongs_to :venue
  after_save :update_venue_end_date
  
  private
    def update_venue_end_date
      unless self.venue.nil?
        self.venue.listing_agent_end_date = self.valid_through
        self.venue.listing_agent_enabled = ((self.exhibitions_enabled || self.events_enabled) && self.valid_through > Time.now)
        self.venue.save_without_validation!
      end
    end
end
