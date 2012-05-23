class CreateVenueTimetables < ActiveRecord::Migration
  def self.up
    create_table :venue_timetables do |t|
      t.belongs_to  :venue
      
      t.boolean     :mon_closed
      t.time        :mon_open
      t.time        :mon_close
      
      t.boolean     :tue_closed
      t.time        :tue_open
      t.time        :tue_close
      
      t.boolean     :wed_closed
      t.time        :wed_open
      t.time        :wed_close
      
      t.boolean     :thu_closed
      t.time        :thu_open
      t.time        :thu_close
      
      t.boolean     :fri_closed
      t.time        :fri_open
      t.time        :fri_close
      
      t.boolean     :sat_closed
      t.time        :sat_open
      t.time        :sat_close
      
      t.boolean     :sun_closed
      t.time        :sun_open
      t.time        :sun_close
      
      t.timestamps
    end
  end

  def self.down
    drop_table :venue_timetables
  end
end
