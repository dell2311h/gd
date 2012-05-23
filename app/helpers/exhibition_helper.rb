module ExhibitionHelper

  def days_left_box(exhibition, visible_before = 10)
    day_count = exhibition.days_left
    if (2..visible_before) === day_count
      raw "<table class='marker-box'><tr><td><b>#{day_count}<br/>days<br/>left</b></td></tr></table>"
    elsif day_count==1
      raw "<table class='marker-box'><tr><td><b>LAST<br/>DAY!</b></td></tr></table>"
    else
      ''
    end
  end

  def exhibition_artists(exhibition)
    result = exhibition.artist_names.slice(0, 3).join(', ')
    result += '...' if exhibition.artists.length > 3
    raw result
  end

  def exhibition_artists_names(exhibition)
    unless exhibition.artists.empty?
      artists = exhibition.artist_names
      last_artist = artists.delete(artists.last)
      if exhibition.artist_names.count > 1
        raw "#{artists.join(', ')}#{artists.empty? ? '' : ' and '}#{last_artist}"
      else
        raw last_artist
      end
    else
      raw "No artists"
    end
  end
  
  def exhibition_artists_names_with_newlines(exhibition)
    unless exhibition.artists.empty?
      artists = exhibition.artist_names
      raw "#{artists.join('<br/>')}"
    else
      raw "No artists"
    end
  end

  
  def exhibition_image(exhibition, size)
    size_px = (size == :large) ? 300 : ((size == :medium) ? 210 : 125)
    title = [exhibition.images.image.artist, exhibition.images.image.title, exhibition.images.image.year, exhibition.images.image.credit].reject{|i| i.nil? || i.blank? }.join(', ') rescue ''
    title = exhibition.title if title.blank?
    img_path = (exhibition.images.image) ? exhibition.images.image.file.url(size) : ( (exhibition.venue.images.image) ? exhibition.venue.images.image.file.url(size) : "/images/noimage_#{(size == :large) ? 300 : ((size == :medium) ? 210 : 125)}.gif" )
    options = ({:title => title, :alt => title, :border=>0})
    raw image_tag(img_path, options)
  end
  
  def image_captions_for(exhibition)
    out = []
    out << "#{exhibition.image_artist}" unless exhibition.images.image.artist.blank?
    out << "<i>#{exhibition.image_title}</i>" unless exhibition.images.image.title.blank?
    out << "#{exhibition.image_year}." unless exhibition.images.image.year.blank?
    out = out.join(', ')
    out << " (#{exhibition.image_credit})" unless exhibition.images.image.credit.blank?
    raw out
  end

  def short_page_entries_info(collection, options = {})
    entry_name = options[:entry_name] ||
      (collection.empty?? 'exhibition' : collection.first.class.name.underscore.sub('_', ' '))

    case collection.size
    when 0; raw "No #{entry_name.pluralize} found"
    when 1; raw "<b>1</b> #{entry_name}"
    else;   raw "<b>#{collection.total_entries}</b> #{entry_name.pluralize}"
    end
  end

  
end
