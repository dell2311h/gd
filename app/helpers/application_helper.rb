module ApplicationHelper
  include VenueHelper
    include ExhibitionHelper

    def validation_error_for(model, attribute)
      err = model.errors[attribute]
      err = err.first if err.is_a?(Array)
      return raw("<span class='error-message'>#{err}</span>") unless err.nil?
      return nil
    end

    def validation_error_for_attachment(model, attachment_name)
      err = []
      err << model.errors["#{attachment_name}_file_name"] unless model.errors["#{attachment_name}_file_name"].nil?
      err << model.errors["#{attachment_name}_file_size"] unless err.any?
      err << model.errors["#{attachment_name}_content_type"] unless err.any?
      return raw(%(<span class="error-message">#{err.compact.shift}</span>)) if err.any?
      return nil
    end

    def format_address(place)
      address = []
      if place.is_a? Venue
        address << "<i>#{place.neighbourhood.name rescue ''}</i>"
        address << place.address
        address << place.address2 unless place.address2.blank?
        address << "#{place.city.name rescue 'TheCity'}, #{place.region.code rescue ''} #{place.postalcode}"
        address << place.country.name rescue ''
        address << ''
        unless place.phone.blank?
          phone = place.phone.gsub(/[-,.()\s]/, '') rescue ''
          address << "Phone: #{phone[0..2]}-#{phone[3..5]}-#{phone[6..-1]}"
        end
        #address << "<a href=\"mailto:#{place.contact_email}\" class=\"bluelink-bold\">#{place.contact_email}</a>"
        address << "<a href=\"#{place.url.include?('http') ? '' : 'http://'}#{place.url}\" target=\"_blank\" class=\"bluelink-bold\">#{place.url}</a>" unless place.url.nil?
      elsif place.is_a? Fair
        address << "<i>#{place.neighbourhood.name rescue ''}</i>"
        address << place.address
        address << "#{place.city.name rescue 'TheCity'}, #{place.region.code rescue ''} #{place.zip}"
        address << place.country.name rescue ''
        address << ''
        #address << "<a href=\"mailto:#{place.contact_email}\" class=\"bluelink-bold\">#{place.contact_email}</a>"
        address << "<a href=\"#{place.website.include?('http') ? '' : 'http://'}#{place.website}\" target=\"_blank\" class=\"bluelink-bold\">#{truncate(place.website, :length=>35)}</a>" unless place.website.nil?
      else
        address << "<b>Address not available</b>"
      end
      raw(address.join('<br/>'))
    end

    def sortable_header(title, sort_key, url_options, update_div_id)
      sorting_on = !params[:sort_key].nil?
      options = {:sort_key => sort_key}
      options = options.merge({:sort_asc => true}) if sorting_on && params[:sort_asc].nil?
      img = ''
      img = ' ' + image_tag("sort_asc.png") if sorting_on && sort_key.eql?(params[:sort_key])
      res = link_to(title + img, :url => url_options.merge(options), :update => update_div_id, :remote => true)
      img = ' ' + image_tag("sort_asc.png") if sorting_on && sort_key.eql?(params[:sort_key])
      raw res
    end

    def facebook_like_button(url)
      raw "<iframe src=\"http://www.facebook.com/plugins/like.php?href=#{URI.escape(url)}&amp;layout=button_count&amp;show_faces=true&amp;width=100&amp;action=like&amp;colorscheme=light&amp;height=21\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:100px; height:21px;\" allowTransparency=\"true\"></iframe>"
    end

    def meta(name,content)
      raw(%(<meta name="description" content="#{h(content)}"/>)) if name == :description && content && content.any?
    end
end
