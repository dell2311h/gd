class GdPageLinkRenderer < WillPaginate::LinkRenderer

  def to_html
    links = @options[:page_links] ? windowed_links : []
    # previous/next buttons
    links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
    links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
    # first/last buttons
    links.unshift page_link_or_span(1, 'disabled prev_page', @options[:first_label])
    links.push    page_link_or_span(@collection.total_pages,     'disabled next_page', @options[:last_label])

    html = links.join(@options[:separator])
    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
  end

  def page_link(page, text, attributes = {})
    @template.link_to text, url_for(page), attributes.merge(:title => "Page #{page}")
  end


end