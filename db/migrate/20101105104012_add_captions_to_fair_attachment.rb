class AddCaptionsToFairAttachment < ActiveRecord::Migration
  def self.up
    add_column :fair_attachments, :artist, :string, :default => nil
    add_column :fair_attachments, :title, :string, :default => nil
    add_column :fair_attachments, :year, :string, :default => nil
    add_column :fair_attachments, :credit, :string, :default => nil
  end

  def self.down
    remove_column :fair_attachments, :artist
    remove_column :fair_attachments, :title
    remove_column :fair_attachments, :year
    remove_column :fair_attachments, :credit
  end
end
