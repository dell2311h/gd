class AddMediumToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :medium_id, :integer
  end

  def self.down
    remove_column :exhibitions, :medium_id, :integer
  end
end
