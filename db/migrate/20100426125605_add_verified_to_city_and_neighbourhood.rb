class AddVerifiedToCityAndNeighbourhood < ActiveRecord::Migration
  def self.up
    add_column :cities, :verified, :boolean, :default => false
    add_column :neighbourhoods, :verified, :boolean, :default => false
    ActiveRecord::Base.connection.execute("UPDATE `cities` SET `verified` = 1 WHERE `id` IN(#{City.find(:all).map(&:id).join(',')})")
    ActiveRecord::Base.connection.execute("UPDATE `neighbourhoods` SET `verified` = 1 WHERE `id` IN(#{Neighbourhood.find(:all).map(&:id).join(',')})") if Neighbourhood.count > 0
  end

  def self.down
    remove_column :cities, :verified
    remove_column :neighbourhoods, :verified
  end
end
