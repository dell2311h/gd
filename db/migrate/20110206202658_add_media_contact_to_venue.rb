class AddMediaContactToVenue < ActiveRecord::Migration
  def self.up
    add_column :users, :media_contact, :string, :default => ''
    add_column :users, :media_contact_title, :string, :default => ''
    add_column :users, :media_contact_email, :string, :default => ''
  end

  def self.down
    remove_column :users, :media_contact
    remove_column :users, :media_contact_title
    remove_column :users, :media_contact_email
  end
end
