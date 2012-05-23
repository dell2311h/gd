class VenueManagerController < ApplicationController
  before_filter :require_venue
  
  def show
    # info summary page
  end
  
  def edit
    # edit form for info page
  end
  
  def update
    
    # render :edit
    redirect_to :show
  end
  
  # form autocomplete actions
  def get_states
    @regions = Region.where(:country_id => params[:country_id]).order('`name` ASC').all
    respond_to do |format|
      format.json do
        render :json => @regions.collect {|r| { :name => r.name, :value => r.id } }.to_json
      end
    end
  end
  
  def get_cities
    @cities = City.where(:region_id => params[:region_id]).order('`name` ASC').all
    respond_to do |format|
      format.json do
        render :json => @cities.collect {|r| { :name => r.name, :value => r.id } }.to_json
      end
    end
  end
  
  def get_neighbourhoods
    @neighbourhoods = Neighbourhood.where(:city_id => params[:city_id]).order('`name` ASC').all
    respond_to do |format|
      format.json do
        render :json => @neighbourhoods.collect {|r| { :name => r.name, :value => r.id } }.to_json
      end
    end
  end
  
  def get_artists
    @artists = Artist.search("*#{params[:q]}*",{ :with => { :venue_id => current_venue.id } }).collect {|a| a.firstname.strip + ' ' + a.lastname.strip } rescue []
  end
  
  def get_artist
    @artist = Artist.search(params[:name], { :with => { :venue_id => current_venue.id } }).to_a.first unless params[:name].blank?
  end
  
  def get_curators
    @curators = Curator.search("*#{params[:q]}*",{ :with => { :venue_id => current_venue.id } }).collect {|a| a.first_name.strip + ' ' + a.last_name.strip } rescue []
  end
  
  def get_curator
    @curator = Curator.search(params[:name], { :with => { :venue_id => current_venue.id } }).to_a.first unless params[:name].blank?
  end
end
