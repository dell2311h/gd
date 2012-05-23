class AddReleaseDateToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :release_date, :date
  end

  def self.down
    remove_column :images, :release_date
  end
end
