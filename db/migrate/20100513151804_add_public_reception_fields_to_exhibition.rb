class AddPublicReceptionFieldsToExhibition < ActiveRecord::Migration
  def self.up
    add_column :exhibitions, :public_reception_start, :time
    add_column :exhibitions, :public_reception_end, :time
    add_column :exhibitions, :public_reception_date, :date
  end

  def self.down
    remove_column :exhibitions, :public_reception_date
    remove_column :exhibitions, :public_reception_end
    remove_column :exhibitions, :public_reception_start
  end
end
