class AddShortPublicationDescriptionToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :associated_publication_desc, :text
  end

  def self.down
    remove_column :exhibitions, :associated_publication_desc
  end
end
