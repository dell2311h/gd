class CreateMediaServices < ActiveRecord::Migration
  def self.up
    create_table :media_services do |t|
      t.string  :name, :default => nil
      t.string  :editor, :default => nil
      t.string  :region, :default => nil
      t.string  :url, :default => nil
      t.boolean  :form_based, :default => false
      t.string  :email
      t.string  :api_url, :default => nil
      t.string  :media_type
      t.datetime  :deadline # ??
      t.boolean :edited, :default => false
      t.text    :description
      t.timestamps
    end
  end

  def self.down
    drop_table :media_services
  end
end
