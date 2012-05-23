class AddInvitationFlagToFairEx < ActiveRecord::Migration
  def self.up
    add_column :fair_exhibitions, :invitation_email_sent, :boolean, :default => false
  end

  def self.down
    remove_column :fair_exhibitions, :invitation_email_sent
  end
end
