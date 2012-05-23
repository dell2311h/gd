class AddFieldsToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :image_artist, :string, :limit => 120
    add_column :exhibitions, :image_title, :string, :limit => 255
    add_column :exhibitions, :image_year, :string, :limit => 30
    add_column :exhibitions, :image_credit, :string, :limit => 30
    
    add_column :exhibitions, :image_file_name,    :string
    add_column :exhibitions, :image_content_type, :string
    add_column :exhibitions, :image_file_size,    :integer
    add_column :exhibitions, :image_updated_at,   :datetime
  end

  def self.down
    remove_column :exhibitions, :image_artist
    remove_column :exhibitions, :image_title
    remove_column :exhibitions, :image_year
    remove_column :exhibitions, :image_credit
    
    remove_column :exhibitions, :image_file_name
    remove_column :exhibitions, :image_content_type
    remove_column :exhibitions, :image_file_size
    remove_column :exhibitions, :image_updated_at
  end
end
