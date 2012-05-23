module FairGroupingsHelper
  def mobile_google_map(markers, map_id = nil)
    converted_markers = []
    markers.each do |marker|
      converted_markers << "{ latitude: #{marker[:lat]}, longitude: #{marker[:lon]} #{(marker[:show_address]) ? ', info: { layer: \'#address\', popup: true }' : '' } }"
    end
    
    raw( "<script>" +
    "$('##{ (map_id.nil?) ? 'map_canvas' : map_id }').googleMaps({" +
    ( (converted_markers.size > 1) ? "markers: [#{converted_markers.join(', ')}]" : "markers: #{converted_markers.first}" ) +
    ", latitude: #{markers.first[:lat]}, longitude: #{markers.first[:lon]}" +
    "});" +
    "</script>")
  end
  
  def mobile_static_map(markers, size=nil)
    converted_markers = []
    markers.each do |marker|
      converted_markers << "&markers=color:#{marker[:color]}|label:#{marker[:label]}|#{marker[:lat]},#{marker[:lon]}"
    end
    
    raw("<img src='http://maps.google.com/maps/api/staticmap"+
    ""+
    "?size=#{(size.nil?) ? '512x512' : size}"+
    "&maptype=roadmap"+
    converted_markers.join('&')+
    "&sensor=false' />")
  end
end
