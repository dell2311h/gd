class RemoveUnusedFieldsFromExhibition < ActiveRecord::Migration
  def self.up
    remove_column :exhibitions, :curator
    remove_column :exhibitions, :media_contact
  end

  def self.down
    add_column :exhibitions, :curator, :string
    add_column :exhibitions, :media_contact, :string
  end
end
