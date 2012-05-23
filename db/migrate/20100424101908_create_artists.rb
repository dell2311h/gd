class CreateArtists < ActiveRecord::Migration
    def self.up
        create_table :artists do |t|
            t.string :firstname
            t.string :lastname
            t.string :middlename
            t.date   :birthdate
            t.date   :deathdate
            t.text   :representation
            t.string :url
            t.string :photourl
            t.text   :biography
            t.boolean :enabled, :default => false
            t.string  :nickname
            t.string  :national_origin
            t.belongs_to :venue
            t.timestamps
        end
  end

  def self.down
    drop_table :artists
  end
end
