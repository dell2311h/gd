class UpdatePreviouslyImportedVenuesWIthoutType < ActiveRecord::Migration
  def self.up
    Venue.find(:all, :conditions => { :gallery_type => nil}).each do |venue|
      venue.gallery_type = 'for_profit'
      venue.save_without_validation!
    end
  end

  def self.down
  end
end
