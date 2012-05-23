class AddAffiliationToCurators < ActiveRecord::Migration
  def self.up
    add_column :curators, :affiliation, :text
  end

  def self.down
    remove_column :curators, :affiliation
  end
end
