class ForceUntypedEventsToBeReceptions < ActiveRecord::Migration
  def self.up
    event_type = EventType.find(:first, :conditions => { :is_reception => true })
    Event.all.each do |event|
      if event.event_type_id.nil?
        event.event_type = event_type
        event.save
      end
    end
  end

  def self.down
  end
end
