class MoveExhibitionPublicReceptionToEventAndRemoveFields < ActiveRecord::Migration
  def self.up
    Exhibition.find(:all).reject {|e| e.public_reception_date.nil? }.each do |ex|
      event = Event.new
      event.exhibition_id = ex.id
      event.venue = ex.venue
      event.event_type = 'reception'
      event.start_date = ex.public_reception_date
      event.start_time = ex.public_reception_start
      event.end_time = ex.public_reception_end
      event.title = ex.title + ' Public Reception'
      event.description = ex.title + ' Public Reception'
      event.save unless event.venue.nil?
    end
    remove_column :exhibitions, :public_reception_date
    remove_column :exhibitions, :public_reception_start
    remove_column :exhibitions, :public_reception_end
  end

  def self.down
    Event.destroy_all
    add_column :exhibitions, :public_reception_date, :date
    add_column :exhibitions, :public_reception_start, :string
    add_column :exhibitions, :public_reception_end, :string
  end
end
