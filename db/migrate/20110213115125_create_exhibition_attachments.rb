class CreateExhibitionAttachments < ActiveRecord::Migration
  def self.up
    create_table :exhibition_attachments do |t|
      t.belongs_to  :exhibition
      t.string    :attachment_file_name
      t.string    :attachment_content_type
      t.integer   :attachment_file_size
      t.datetime  :attachment_updated_at
      
      t.string    :artist, :limit => 120
      t.string    :title, :limit => 255
      t.string    :year, :limit => 30
      t.string    :credit, :limit => 30
    end
  end

  def self.down
    drop_table :exhibition_attachments
  end
end
