class HomeController < ApplicationController

  SEARCH_HINT = {
    :title => "venue, exhibition title, or artist",
    :place=> "neighborhood, city or state",
    :date => "select date"
  }

  END_OF_DAYS = Time.utc(2037, 12, 31, 23, 59, 59, 0)

  def searchautocomplete
    search_string = params[:q]
    @search_options = {}   
    @search_options[:enabled] = 1
    @search_options[:without] = { :close_date => Time.at(0)..Time.now.yesterday }
    @search_options[:classes] = [Exhibition, Event]    
    @search_options[:match_mode] = :any
    venues = ThinkingSphinx.search search_string, @search_options
    @result = venues.map do |m|
      {
        :value => m.title,
        :data => { 
          :title => m.title,
          :description => m.description[0..30].gsub(/<\/?[^>]*>/, "") + "...",
          :url => m.class.to_s.downcase.eql?('event') ? venue_event_url(m.venue_id,m.id) : venue_exhibition_url(m.venue_id,m.id),
          :img => m.image_path(:small)
        }
      }
    end
    respond_to do |format|
      format.json { render :json => @result }
    end
  end
  
  def index 
    @per_page = 10
    @cur_page = params[:page].to_i == 0 ? 1 : params[:page].to_i
    search_string = params[:search]
    region_grouping_id = params[:region_grouping_id]
    neighbourhood_id = params[:neighbourhood_id]
    @search_options = {}   
    @search_options[:enabled] = 1
    @search_options[:without] = { :close_date => Time.at(0)..Time.now.yesterday }
    @search_options[:classes] = [Exhibition, Event]

    if search_string
      #  Search index page  
      @search_options[:page] = @cur_page
      @search_options[:per_page] = @per_page
      @search_options[:match_mode] = :any
      @search_options[:order] = "@relevance DESC, updated_at DESC"
      venues = ThinkingSphinx.search search_string, @search_options
      @result = venues

      # !!! WARNING - may will be need
      @search_options.delete(:page)
      @search_options.delete(:per_page)

      @facets = ThinkingSphinx.facets search_string, :enabled => 1,
        :facets => [:city_id, :neighbourhood_id,],
        :without => { :close_date => Time.at(0)..Time.now.yesterday },
        :classes => [Exhibition, Event],
        :group_by => 'city_id',
        :group_function => :attr

      @filter_cityes = {}

      @facets[:city_id].map do |option, count|
        @facets.for(:city_id => option).map {|v| @filter_cityes[v.venue.city.name] = {:count => count, :neighbourhoods => []}}
      end

      @facets[:neighbourhood_id].map do |option, count|
        @facets.for(:neighbourhood_id => option).map {|v| @filter_cityes[v.venue.city.name][:neighbourhoods] << {:name => v.venue.neighbourhood.name, :count => count}}
      end
    else
      #  Main index page
      @search_options[:all_facets] = true
      @search_options[:facets] = (region_grouping_id || neighbourhood_id) ? [:neighbourhood_id] : [:region_grouping_id]
      @search_options[:with] = { :region_grouping_id => region_grouping_id } if region_grouping_id
      
      if neighbourhood_id
        #  Pagination for this page
        @search_options[:with] = { :neighbourhood_id => neighbourhood_id }
        @search_options[:page] = @cur_page
        @search_options[:per_page] = @per_page

        @city = Neighbourhood.find(neighbourhood_id).city rescue nil
        @neighbourhoods = ThinkingSphinx.search :enabled => 1,
          :without => { :close_date => Time.at(0)..Time.now.yesterday, :neighbourhood_id => neighbourhood_id },
          :classes => [Exhibition, Event],
          :group_by => 'neighbourhood_id',
          :group_function => :attr,
          :with => {:city_id => @city.id}
      end
      
      facets = ThinkingSphinx.facets @search_options 

      @result = []
      facets.each do |facet, fs|
        fs.each do |option, count|  
          case 
          when region_grouping_id || neighbourhood_id
            result_items = facets.for( :neighbourhood_id => option ).to_a
            result_items_name = result_items[0].venue.neighbourhood.try(:name)
          else
            result_items = facets.for( :region_grouping_id => option ).to_a
            result_items_name = result_items[0].venue.city.region_grouping.try(:name)
          end
          @result.push([result_items, result_items_name, count, option])
        end
      end
    end 

    case 
    when search_string
      render 'index_search'
    when region_grouping_id
      render 'index_region'
    when neighbourhood_id
      render 'index_neighbourhood'
    else
      render 'index'
    end
  end
  
  def events_calendar
    @show_banner = false
    options = {:per_page => 10000000000, :page => 1, :order => "`neighborhood_sort` ASC"}
    @date = begin
              parts = params[:date].split(',')
              Date.commercial(parts[1].to_i, parts[0].to_i, 1)
           rescue
              Date.today
           end
    start_date = Time.parse(Date.commercial(@date.cwyear, @date.cweek, 1).to_s)
    end_date = Time.parse(Date.commercial(@date.cwyear, @date.cweek, 7).to_s).tomorrow
    
    @prev_week_str = -1.week.since(@date).strftime('%W,%Y')
    @next_week_str = 1.week.since(@date).strftime('%W,%Y')
    #options.merge!({ :with => { :open_date => start_date..end_date, :close_date => start_date..end_date } })
    #options.merge!({ :without => { :open_date => Time.at(0)..start_date.yesterday, :close_date => end_date.tomorrow..END_OF_DAYS }})
    options.merge!({ :with => { :open_date => 1.year.ago..end_date }})
    @area = RegionGrouping.find(params[:area]) rescue nil
    area = @area.keywords.split(/\s+/).join(' ') rescue ''
    
    event_ids = FullEvent.search_for_ids(area, options)
    # move filtering by date to sql!
    #conditions = ""
    #conditions << "id IN(#{event_ids.join(',')}) " unless event_ids.empty?
    #conditions << "`user`.`time_table`"?
    @events = Event.find(:all, :conditions => { :id => event_ids }, :include => [ { :venue => [ :neighbourhood, :venue_timetable, :region, :city, :country ] }, { :exhibition => :artists }, :event_type ] ) rescue []

    @neighbourhoods = {}
    @events.each do |event|
      @neighbourhoods[event.venue.neighbourhood] = { :count => 0, :wdays => [] } if @neighbourhoods[event.venue.neighbourhood].nil?
      (0..6).each do |wday|
        @neighbourhoods[event.venue.neighbourhood][:wdays][wday] = [] if @neighbourhoods[event.venue.neighbourhood][:wdays][wday].nil?
        comparison_date = Date.commercial(@date.cwyear, @date.cweek, wday+1)
        if date_in_range(comparison_date, event, event.venue.venue_timetable)
          @neighbourhoods[event.venue.neighbourhood][:wdays][wday] << event
          @neighbourhoods[event.venue.neighbourhood][:count] += 1
        end
      end
    end

  end
  
  protected
    def date_in_range(date, event, timetable = nil)
      date = Time.parse(date.to_s).to_i
      start_date = Time.parse(event.start_date.to_s).to_i
      end_date = Time.parse(event.end_date.to_s).to_i
      if timetable.nil? || (!timetable.nil? && timetable.by_appointment)
        (start_date..end_date).include?(date)
      else
        !timetable.send("#{Date::ABBR_DAYNAMES[Time.at(date).wday].downcase}_closed") && ((start_date..end_date).include?(date)) # timetable.by_appointment || 
      end
    end
  
  
end
