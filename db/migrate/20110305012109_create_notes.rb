class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :author_id, :null => false
      t.string :author_type, :limit => 30, :null => false
      t.integer :subject_id, :null => false
      t.string :subject_type, :limit => 30, :null => false
      t.string :text, :limit => 2048, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
