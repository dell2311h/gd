class AddDefaultRecipientToContactPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :default_recipient, :string, :default => 'contact@gallerydog.info'
  end

  def self.down
    remove_column :pages, :default_recipient
  end
end
