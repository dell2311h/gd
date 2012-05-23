module VenueHelper

  def venue_image(venue, size)
    unless venue.nil?
      img_path = (venue.image?) ? venue.image.url(size) : "/images/noimage_#{(size == :large) ? 300 : ((size == :medium) ? 210 : 125)}.gif"
      options = ({:title => venue.name, :alt => venue.name, :border=>0})
      raw image_tag(img_path, options)
    end
  end

  def venue_logo(venue, size)
    unless venue.nil?
      img_path = (venue.logo?) ? venue.logo.url(size) : "/images/noimage_#{(size == :large) ? 300 : ((size == :medium) ? 210 : 125)}.gif"
      options = ({:title => "#{venue.name} Logo", :alt => venue.name, :border=>0})
      raw image_tag(img_path, options)
    end
  end

  def venue_schedule_list(venue)
    return 'n/a' if venue.venue_timetable.nil?
    result = venue.venue_timetable.schedule.map { |d| d.gsub(/(\w+) (.+)/, '<tr><td width="70">\1</td><td>\2</td></tr>') } rescue []
    result << "<tr><td colspan='2'>#{(result.size > 0) ? 'and by appointment':'By appointment only'}</td></tr>" if venue.venue_timetable.by_appointment
    raw "<table width='100%'>#{result.join}</table>"
  end
  
  def venue_is_open(venue, include_hours = false)
    unless include_hours
      unless venue.venue_timetable.send("#{Time.now.strftime('%a').downcase}_closed")
        open_time =venue.venue_timetable.send("#{Time.now.strftime('%a').downcase}_open").strftime('%I:%M%p').gsub(/^0/,'').downcase
        close_time = venue.venue_timetable.send("#{Time.now.strftime('%a').downcase}_close").strftime('%I:%M%p').gsub(/^0/,'').downcase
        raw "<b style='color:#ff982d;'>OPEN #{Time.now.strftime('%A').pluralize.upcase}<br>#{open_time} - #{close_time}</b>"
      else
        raw "<b style='color:#ff0000;'>CLOSED #{Time.now.strftime('%A').pluralize.upcase}</b>"
      end
    else
    
    end
  end

  def manage_venue_link
    link_to 'account manager', venue_manage_path(current_venue), :class => 'bluelink-normal'
  end

  def venue_schedule_list_ul(venue)
    return 'n/a' if venue.venue_timetable.nil?
    result = venue.venue_timetable.schedule.map { |d| d.gsub(/(\w+) (.+)/, '<li><span>\1</span>\2</li>') } rescue []
    raw "<ul class='hours'>#{result.join}</ul>"
  end

  def venues_show_in_gmap(items)
    markers = []
    # iteь = @result.first.first.map
    items.map do |item|
      markers << item.venue.gmap_location unless markers.include?(item.venue.gmap_location) rescue nil
    end

    cnt = 0
    m = markers.shift if markers.any?
    url = "http://maps.googleapis.com/maps/api/staticmap?center=#{m}&size=245x185&markers=size:mid|color:red|label:A|#{m}"
  
    markers.map do |m|
      url << "&markers=size:mid|color:blue|label:#{cnt+=1}|#{m}"
    end
    url << "&sensor=false"                  
  end

  def gallery_types_for_select
    Venue::VENUE_TYPES.each_key {|key,value| [key, value] }
  end

end
