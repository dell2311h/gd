class CreateNeighbourhoods < ActiveRecord::Migration
  def self.up
    create_table :neighbourhoods do |t|
        t.references :city, :null => false
        t.string :name, :limit => 100, :null => false
        t.timestamps
    end
  end

  def self.down
    drop_table :neighbourhoods
  end
end
