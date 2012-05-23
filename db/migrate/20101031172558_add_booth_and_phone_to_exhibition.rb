class AddBoothAndPhoneToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :booth, :string, :default => nil
    add_column :exhibitions, :phone_at_fair, :string, :default => nil
  end

  def self.down
    remove_column :exhibitions, :booth
    remove_column :exhibitions, :phone_at_fair
  end
end
