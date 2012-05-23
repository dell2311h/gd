class MoveVenuesToSeparateTable < ActiveRecord::Migration
  def self.up
    create_table "venues" do |t|
      # common
      t.string :name, :limit => 100, :default => '', :null => true
      t.string :email, :limit => 100
      t.string :crypted_password, :limit => 128, :null => false, :default => ""
      t.string :salt, :limit => 128, :null => false, :default => ""
      t.datetime :created_at
      t.datetime :updated_at
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.string    :persistence_token,   :null => false
      t.string    :single_access_token, :null => false
      t.string    :perishable_token,    :null => false
      t.integer   :login_count,         :null => false, :default => 0
      t.integer   :failed_login_count,  :null => false, :default => 0
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip
      # common
      
      # venue
      t.string :address, :limit => 255
      t.string :address2, :limit => 255
      t.string :postalcode, :limit => 10
      t.integer :country_id
      t.integer :region_id
      t.integer  :city_id
      t.integer  :neighbourhood_id
      t.string :phone, :limit => 50
      t.string :ipaddress, :limit => 50
      t.integer :login_count, :default => 0
      t.string :gallery_type, :limit => 25
      t.text :description
      t.string :url
      t.string :contact_email
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.boolean  :status, :default => false
      t.string :transit
      t.string :lat
      t.string :lng
      t.boolean  :notify_monthly, :default => false
      t.string :invitation_token
      t.boolean :listing_agent_enabled, :default => false
      t.datetime :listing_agent_end_date
      t.text :boilerplate_info
      t.string :media_contact, :default => ''
      t.string :media_contact_title, :default => ''
      t.string :media_contact_email, :default => ''
      t.string :logo_file_name
      t.string :logo_content_type
      t.integer :logo_file_size
      t.datetime :logo_updated_at
      #venue
    end
    
    add_index :venues, ["email"], :name => "index_users_on_email", :unique => true
    #add_index :venues, ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
    
    v = Venue.new
    User.find(:all, :conditions => { :type => 'Venue' }).each do |venue|
      fields, values = [],[]
      venue.attributes.each do |a|
        if v.has_attribute?(a[0]) || a[0] == 'id'
          fields << a[0]
          values << Venue.sanitize(a[1])
        end
      end
      ActiveRecord::Base.connection.execute("insert into venues(`#{fields.join('`,`')}`) values(#{values.join(",")})")
      ActiveRecord::Base.connection.execute("delete from users where id = #{venue.id};")
    end
  end

  def self.down
  end
end
