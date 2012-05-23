class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.string    :file_file_name
      t.string    :file_content_type
      t.integer   :file_file_size
      t.datetime  :file_updated_at
      
      t.string    :kind
      
      t.string    :artist
      t.string    :title
      t.string    :year
      t.string    :credit
      t.string    :description
      t.string    :note
      t.string    :medium
      t.string    :style
      t.boolean   :available, :default => true
      t.boolean   :available_for_press, :default => false
      t.boolean   :for_sale, :default => false
    end
  end

  def self.down
    drop_table :images
  end
end