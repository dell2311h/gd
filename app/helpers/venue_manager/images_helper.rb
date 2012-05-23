module VenueManager::ImagesHelper

	def search_text_by_kind(kind)
		if kind == Image::KINDS[:publication_pdf] 
			'search pdfs'
		elsif kind.present?
			'search images'
		else
			'search'
    	end
	end
end
