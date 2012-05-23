module HomeHelper

	def paginate(cur_page,per_page,total)
		total_pages = (total.to_f/per_page).ceil
		return if total_pages <= 1
		if cur_page > 1
			backtostart = content_tag(:li, link_to('',url_params(total_pages), :class => 'back-to-start'), :class => 'arrow')
			back = content_tag(:li, link_to('',url_params(total_pages), :class => 'back'), :class => 'arrow')
		else
			backtostart = content_tag(:li, link_to('','', :class => 'back-to-start disable', :onclick => "return false;"), :class => 'arrow')
			back = content_tag(:li, link_to('','', :class => 'back disable', :onclick => "return false;"), :class => 'arrow')
		end
		if cur_page < total_pages
			forward = content_tag(:li, link_to('',url_params(total_pages), :class => 'forward'), :class => 'arrow')
			forwardtoend = content_tag(:li, link_to('',url_params(total_pages), :class => 'forward-to-end'), :class => 'arrow')
		else
			forward = content_tag(:li, link_to('','', :class => 'forward disable', :onclick => "return false;"), :class => 'arrow')
			forwardtoend = content_tag(:li, link_to('','', :class => 'forward-to-end disable', :onclick => "return false;"), :class => 'arrow')
		end

		html = backtostart << back
		1.upto(total_pages) {|i| html << content_tag(:li, link_to(i, url_params(i), :class => "#{'active' if cur_page.to_i == i}")) }
		html << forward << forwardtoend
		raw(html)
	end

protected

	 def url_params(page)
	 	params[:page] = page
	 	params
	 end
	
end
