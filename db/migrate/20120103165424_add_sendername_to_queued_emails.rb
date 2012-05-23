class AddSendernameToQueuedEmails < ActiveRecord::Migration
  def self.up
  	add_column 'queued_emails', 'sender_name', :string, :null => true
  end

  def self.down
  	remove_column 'queued_emails', 'sender_name'
  end
end
