class AddContactEmailToVenue < ActiveRecord::Migration
  def self.up
    add_column :users, :contact_email, :string, :limit => 120
  end

  def self.down
    remove_column :users, :contact_email
  end
end
