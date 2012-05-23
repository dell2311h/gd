class CreateMediaServiceSetups < ActiveRecord::Migration
  def self.up
    create_table :media_service_setups do |t|
      t.belongs_to  :venue
      t.belongs_to  :media_service
      t.string      :media_site_login
      t.string      :media_site_password
    end
  end

  def self.down
    drop_table :media_site_setups
  end
end
