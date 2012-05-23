class AddExhibitionType < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :is_multiple, :boolean, :default => false
    Exhibition.find(:all).each do |ex|
      if ex.artists.count > 1
        ex.is_multiple = true
        ex.save!
      end
    end
  end

  def self.down
    remove_column :exhibitions, :is_multiple, :boolean, :default => false
  end
end
