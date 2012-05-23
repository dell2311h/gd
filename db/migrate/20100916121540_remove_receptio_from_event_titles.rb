class RemoveReceptioFromEventTitles < ActiveRecord::Migration
  def self.up
    Event.find(:all, :include => [ :event_type ]).each do |event|
      if event.event_type.is_reception
        unless event.title.nil?
          event.title = event.title.gsub(/\sReception/,'')
          event.save!
        end
      end
    end
  end

  def self.down
  end
end
