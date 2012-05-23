class AddCropDataToImageContainingModels < ActiveRecord::Migration
  def self.up
    add_column :events, :crop_data, :string, :default => nil
    add_column :exhibitions, :crop_data, :string, :default => nil
    add_column :users, :crop_data, :string, :default => nil
  end

  def self.down
    remove_column :events, :crop_data
    remove_column :exhibitions, :crop_data
    remove_column :users, :crop_data
  end
end
