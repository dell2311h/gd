class AddPageToContactMessage < ActiveRecord::Migration
  def self.up
    add_column :contact_messages, :page_id, :integer, :default => nil
  end

  def self.down
    remove_column :contact_messages, :page_id
  end
end
