class RemoveImageRelatedFieldsFromExhibitions < ActiveRecord::Migration
  def self.up
    remove_column :exhibitions, :publication_pdf_file_name
    remove_column :exhibitions, :publication_pdf_content_type
    remove_column :exhibitions, :publication_pdf_file_size
    remove_column :exhibitions, :publication_pdf_updated_at
    
    remove_column :exhibitions, :image_file_name
    remove_column :exhibitions, :image_content_type
    remove_column :exhibitions, :image_file_size
    remove_column :exhibitions, :image_updated_at
    
    remove_column :exhibitions, :image_artist
    remove_column :exhibitions, :image_year
    remove_column :exhibitions, :image_title
    remove_column :exhibitions, :image_credit
    
    drop_table :exhibition_attachments
  end

  def self.down
  end
end