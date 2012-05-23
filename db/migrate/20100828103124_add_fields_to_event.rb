class AddFieldsToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :event_type_id, :integer
    add_column :events, :single_day, :boolean, :default => true
    add_column :events, :cost, :float, :default => 0.0
    Event.all.each do |e|
      if e.event_type == 'Reception'
        e.event_type_id = EventType.find(:first).id
        e.save!
      end
    end
  end

  def self.down
    remove_column :events, :event_type_id
    remove_column :events, :single_day
    remove_column :events, :cost
  end
end
