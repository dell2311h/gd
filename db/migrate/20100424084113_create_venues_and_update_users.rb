class CreateVenuesAndUpdateUsers < ActiveRecord::Migration
  def self.up
    add_column  :users, :type, :string, :limit => 20, :null => false
    # Common
    add_column  :users, :firstname, :string, :limit => 100
    add_column  :users, :lastname, :string, :limit => 100
    add_column  :users, :address, :string, :limit => 255
    add_column  :users, :postalcode, :string, :limit => 10
    add_column  :users, :phone, :string, :limit => 50
    add_column  :users, :ipaddress, :string, :limit => 50
    add_column  :users, :birthdate, :date
    add_column  :users, :gender, :boolean, :default => true
    add_column  :users, :income, :string, :limit => 80
    add_column  :users, :country_id, :integer
    add_column  :users, :region_id, :integer
    add_column  :users, :city_id, :integer
    add_column  :users, :neighbourhood_id, :integer
    add_column  :users, :login_count, :integer, :default => 0
    add_column  :users, :gallery_type, :string, :limit => 100
  end

  def self.down
    remove_column  :users, :type
    remove_column  :users, :firstname
    remove_column  :users, :lastname
    remove_column  :users, :address
    remove_column  :users, :postalcode
    remove_column  :users, :phone
    remove_column  :users, :ipaddress
    remove_column  :users, :birthdate
    remove_column  :users, :gender
    remove_column  :users, :income
    remove_column  :users, :country_id
    remove_column  :users, :region_id
    remove_column  :users, :city_id
    remove_column  :users, :neighbourhood_id
    remove_column  :users, :login_count
    remove_column  :users, :gallery_type
  end
end
