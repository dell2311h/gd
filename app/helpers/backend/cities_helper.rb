module Backend::CitiesHelper
	#  Array of coutries for select tag
	def countries_for_select
    	Country.all.map { |p| [p.name, p.id] }
  	end

	#  Array of regions for select tag
  	def regions_for_select
  		Region.all.map { |p| [p.name, p.id] }
  	end
end
