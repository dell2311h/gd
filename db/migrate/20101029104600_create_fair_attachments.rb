class CreateFairAttachments < ActiveRecord::Migration
  def self.up
    create_table :fair_attachments do |t|
      t.belongs_to  :fair_exhibition
      t.string      :image_file_name
      t.string      :image_content_type
      t.integer     :image_file_size
      t.datetime    :image_updated_at
    end
  end

  def self.down
    drop_table :fair_attachments
  end
end
