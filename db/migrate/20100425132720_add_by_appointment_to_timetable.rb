class AddByAppointmentToTimetable < ActiveRecord::Migration
  def self.up
    add_column :venue_timetables, :by_appointment, :boolean, :default => false
  end

  def self.down
    remove_column :venue_timetables, :by_appointment
  end
end
