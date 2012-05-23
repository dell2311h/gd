class RemoveNotUsedAttributesFromCities < ActiveRecord::Migration
  def self.up
    remove_column :cities, :timezone
    remove_column :cities, :dma_id
    remove_column :cities, :county
    remove_column :cities, :code
  end

  def self.down
  end
end
