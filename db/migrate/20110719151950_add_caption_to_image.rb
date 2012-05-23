class AddCaptionToImage < ActiveRecord::Migration
  def self.up
    add_column :images, :caption, :string
  end

  def self.down
    remove_column :images, :caption
  end
end
