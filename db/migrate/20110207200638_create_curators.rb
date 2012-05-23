class CreateCurators < ActiveRecord::Migration
  def self.up
    create_table :curators do |t|
      t.belongs_to  :venue
      t.string  :first_name
      t.string  :last_name
      t.string  :title
    end
  end

  def self.down
    drop_table :curators
  end
end
