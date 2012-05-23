class ChangeArtistFields < ActiveRecord::Migration
  def self.up
    remove_column :artists, :url
    remove_column :artists, :photourl
    remove_column :artists, :nickname
    remove_column :artists, :national_origin
    remove_column :artists, :representation
    
    add_column  :artists, :born_in, :string
    add_column  :artists, :born_in_country, :string
    add_column  :artists, :live_in, :string
    add_column  :artists, :live_in_country, :string
    add_column  :artists, :represented_by_venue, :boolean, :default => false
  end

  def self.down
    add_column :artists, :url, :string
    add_column :artists, :photourl, :string
    add_column :artists, :nickname, :string
    add_column :artists, :national_origin, :string
    add_column :artists, :representation, :string
    
    remove_column  :artists, :born_in
    remove_column  :artists, :born_in_country
    remove_column  :artists, :live_in
    remove_column  :artists, :live_in_country
    remove_column  :artists, :represented_by_venue
  end
end
