module EventsHelper
  def event_image(event, size)
    unless event.nil?
      img_path = (event.images.image) ? event.images.image.file.url(size) : ( (event.venue.images.image) ? event.venue.images.image.file.url(size) : "/images/noimage_#{(size == :large) ? 300 : ((size == :medium) ? 210 : 125)}.gif" )
      options = ({:title => event.title, :alt => event.title, :border=>0})
      raw image_tag(img_path, options)
    end
  end
end
