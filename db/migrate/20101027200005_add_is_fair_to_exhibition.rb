class AddIsFairToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :for_fair, :boolean, :default => false
  end

  def self.down
    remove_column :exhibitions, :for_fair
  end
end
