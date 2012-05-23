class RemoveLogoFieldsFromVenue < ActiveRecord::Migration
  def self.up
    remove_column :venues, :logo_file_name
    remove_column :venues, :logo_content_type
    remove_column :venues, :logo_file_size
    remove_column :venues, :logo_updated_at
  end

  def self.down
  end
end
