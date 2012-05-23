class VenueTimetable < ActiveRecord::Base
  belongs_to  :venue
  #def self.formatted_time_accessor
  #  Date::ABBR_DAYNAMES.each do |day, i|
  #    class_eval do %w{
  #      def #{day}_open_formatted
  #          read_attribute(:#{day}_open).strftime("%I:%M %p") rescue ''
  #        end

  #        def #{day}_close_formatted
  #          read_attribute(:#{day}_close).strftime("%I:%M %p")  rescue ''
  #        end
  #      }
  #    end
  #  end
  #end
  #formatted_time_accessor
  
  Date::ABBR_DAYNAMES.each do |day|
    VenueTimetable.class_eval do
        define_method("#{day.downcase}_is_open") do
          !self.send("#{day.downcase}_closed")
        end
        
        define_method("#{day.downcase}_is_open=") do |val|
          self.send("#{day.downcase}_closed=", !((val.to_i==1)?true:false))
        end
    end
  end

=begin  
  
=end

  def schedule
    result = []
    sunday_present = false
    Date::ABBR_DAYNAMES.each_with_index do |day, index|
      if self.send("#{day.downcase}_close") || self.send("#{day.downcase}_open")
        closed = self.send("#{day.downcase}_closed")
        unless closed
          bd = self.send("#{day.downcase}_open").strftime('%I:%M %p').gsub(/^0/,'') + ' - ' + self.send("#{day.downcase}_close").strftime('%I:%M %p').gsub(/^0/,'')
          result << "#{Date::DAYNAMES[index]} #{bd}" #
          sunday_present = true if day.downcase == 'sun'
        end
      end
      # result << "#{Date::DAYNAMES[index]} #{closed ? 'Closed' : bd}"
    end
    result << result.shift if sunday_present
    result
  end
  
  private

  def validate
    Date::ABBR_DAYNAMES.each_with_index do |day, i|
      time_not_set = ( self.send("#{day.downcase}_close").nil? or self.send("#{day.downcase}_open").nil? )

      #  Allow nil, remove this row if need required field
      time_not_set = false

      closed = self.send("#{day.downcase}_closed")
      time_wrong = !time_not_set && !closed && (self.send("#{day.downcase}_close").to_i < self.send("#{day.downcase}_open").to_i)
      if (time_not_set && !closed)
        errors[:"#{day.downcase}_open"] << "#{Date::DAYNAMES[i]} time is required"
      elsif time_wrong
        errors[:"#{day.downcase}_close"] << "#{Date::DAYNAMES[i]} close time should be later then open time"
      end
    end unless self.new_record?
  end
=begin  
    def validate_timings(record)
      Date::ABBR_DAYNAMES.each_with_index do |day, idx|
        record.errors[:"#{day.downcase}_close"] << "#{Date::DAYNAMES[idx]} closing time should be greater then open time" if self.send("#{day.downcase}_close") <= self.send("#{day.downcase}_open")
      end
    end
=end
end
