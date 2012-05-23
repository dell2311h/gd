require 'fastercsv'
require 'pp'
class Backend::FairsController < BackendController
  def index
    @fair_grouping = FairGrouping.find(params[:fair_grouping_id])
    @fairs = @fair_grouping.fairs.search params[:search], { :page => params[:page], :order => (params[:sort_on].to_sym rescue :name), :sort_mode => :desc }
  end
  
  def new
    @fair_grouping = FairGrouping.find(params[:fair_grouping_id])
    @fair = Fair.new
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair].nil? && !params[:fair][:country_id].blank?) ? params[:fair][:country_id] : @countries.first.id ) ] )
    @venues = Venue.find :all
  end
  
  def create
    venue_csv = params[:fair].delete(:venue_csv)
    @fair_grouping = FairGrouping.find(params[:fair_grouping_id])
    @fair = Fair.new params[:fair]
    @fair.country = Country.find params[:fair][:country_id] rescue nil
    @fair.region = Region.find params[:fair][:region_id] rescue nil
    @fair.city = City.find(:first, :conditions => { :country_id => params[:fair][:country_id], :region_id => params[:fair][:region_id], :name => params[:fair][:city_name] } ) rescue nil
    @fair.neighbourhood = Neighbourhood.find_by_name(params[:fair][:neighbourhood_name], :conditions => ['city_id = ?', @fair.city.id])
    @fair.fair_grouping = @fair_grouping
    @fair.venue_ids = [] if params[:fair][:venue_ids].nil? || params[:fair][:venue_ids].empty?
    if @fair.save
      redirect_to :action => 'index'
    else
      @countries =  Country.find(:all)
      @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair][:country_id].blank?) ? params[:fair][:country_id] : @countries.first.id ) ] )
      @venues = Venue.find :all
      render :action => 'new'
    end
  end
  
  def edit
    @fair_grouping = FairGrouping.find(params[:fair_grouping_id])
    @fair = Fair.find params[:id]
    @countries =  Country.find(:all)
    @regions = Region.find(:all, :conditions => [ 'country_id = ?', @fair.country.id ] )
    @venues = Venue.find :all
  end
  
  def update
    params[:fair][:venue_ids] = [] if params[:fair][:venue_ids].nil?
    venue_ids_addon = []
    
    venue_csv = params[:fair].delete(:venue_csv)
    venue_ids_addon = parse_venues_csv(venue_csv) unless venue_csv.nil?
    params[:fair][:venue_ids] = params[:fair][:venue_ids] + venue_ids_addon
    
    @fair_grouping = FairGrouping.find(params[:fair_grouping_id])
    @fair = Fair.find params[:id]
    @fair.country = Country.find params[:fair][:country_id] rescue nil
    @fair.region = Region.find params[:fair][:region_id] rescue nil
    @fair.city = City.find(:first, :conditions => { :country_id => params[:fair][:country_id], :region_id => params[:fair][:region_id], :name => params[:fair][:city_name] } ) rescue nil
    @fair.neighbourhood = Neighbourhood.find_by_name(params[:fair][:neighbourhood_name], :conditions => ['city_id = ?', @fair.city.id])
    @fair.fair_grouping = @fair_grouping
    
    if @fair.update_attributes params[:fair]
      @fair.fair_exhibitions(true)
      @fair.fair_exhibitions.each do |fe|
        unless fe.invitation_email_sent?
          NotificationsMailer.deliver_fair_invitation(fe.venue, fe.fair, fe)
          fe.invitation_email_sent = true
          fe.save!
        end
      end
      
      redirect_to :action => 'index'
    else
      @countries =  Country.find(:all)
      @regions = Region.find(:all, :conditions => [ 'country_id = ?', ( (!params[:fair][:country_id].blank?) ? params[:fair][:country_id] : @countries.first.id ) ] )
      @venues = Venue.find :all
      render :action => 'edit'
    end
  end
  
  def destroy
    @fair = Fair.find params[:id]
    @fair.destroy
    redirect_to :action => 'index' 
  end
  
  protected
    def parse_venues_csv(tempfile)
      require 'pp'
      venues = []
      field_names = nil
      fields_mapping = { "Fair" => :fair,	"Gallery name" => :name,	"Country" => :country_name,	"State/Region" => :region_name,	"City" => :city_name, "Street Address" => :address, "Zip" => :zip,
        "Neighborhood" => :neighbourhood_name,	"Gallery website" => :url,	"Gallery Email" => :email, "Phone" => :phone }
      
      FasterCSV.foreach(tempfile.path, :quote_char => '"', :row_sep =>:auto) do |row|
        venue_props = {}
        
        if field_names.nil?
          field_names = row
        else
          row.each_index do |index|
            venue_props[fields_mapping[field_names[index]]] = (row[index].strip rescue row[index])
          end
        end
        
        begin
            venue = Venue.find(:first, :conditions => "`name`='#{venue_props[:name]}' and `contact_email` = '#{venue_props[:email]}'") # `url` LIKE '%#{venue_props[:url]}%' and
            venue ||= Venue.new
            # pp venue_props
            if venue.new_record?
              venue_props.each_pair do |key, value|
                value = value.strip unless value.nil?
                begin
                  venue.send("#{key}=", value)
                  # pp value if key == :city_name
                rescue
                  # pp "#{key}:#{value}"
                  if key == :country_name
                    venue.country = Country.find_by_name(value) || Country.find_by_iso2(value) || Country.find_by_iso3(value)
                  elsif key == :region_name
                    venue.region = Region.find_by_name(value) || Region.find_by_code(value)
                  elsif key == :city_name
                    venue.city = City.find_by_name(value, :conditions => { :country_id => venue.country_id }) || City.find(:first, :conditions => { :name => value })
                  end
                end
              end
              
              venue.gallery_type = 'for_profit'
              venue.contact_email = venue.email
              venue.password = venue.password_confirmation = Venue.make_token
              venue.really_basic_data = true
              venue.skip_desc_validation = true
              venue.authorized_representative = '1'
              venue.terms_agreed = '1'
              venue.skip_default_email = true
              venue.invitation_token = Venue.make_token

              if venue.valid?
                setup_timetable_for_venue(venue)
                venue.save(true)
                #venue.save(false)
              end
              unless venue.errors.empty?
                pp venue.name
                pp venue.errors.full_messages
              end
              venues << venue.id unless venue.id.nil?
            end
        rescue
        
        end
      end
      
      venues
    end
    
    def setup_timetable_for_venue(venue)
      tt = VenueTimetable.new
      Date::ABBR_DAYNAMES.each do |day|
        tt.send("#{day.downcase}_closed=", true)
      end
      venue.venue_timetable = tt
    end
    
end
