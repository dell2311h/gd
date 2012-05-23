class FixBrokenCitiesForVenues < ActiveRecord::Migration
  def self.up
    Venue.find(:all).each do |venue|
      if venue.region_id != venue.city.region_id
        venue.city = City.find(:all, :conditions => { :region_id => venue.region_id }).first rescue venue.city
        venue.save_without_validation!
      end
    end
  end

  def self.down
  end
end
