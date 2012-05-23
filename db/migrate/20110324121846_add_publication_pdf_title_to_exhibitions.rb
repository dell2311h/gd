class AddPublicationPdfTitleToExhibitions < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :publication_pdf_title, :string
  end

  def self.down
    remove_column :exhibitions, :publication_pdf_title
  end
end
