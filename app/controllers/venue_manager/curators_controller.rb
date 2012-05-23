class VenueManager::CuratorsController < VenueManager::VenueManagerBaseController
  before_filter :before_filter_curator, :only => [:edit, :update, :destroy]

  def index
    if params[:filter].blank?
      @curators = current_venue.curators.sort_by_name 
    else
      @curators = current_venue.curators.search params[:filter], 
        :sort_mode => :extended,
        :order => 'last_name ASC, first_name ASC'
    end
  end
  
  def new
    @curator = Curator.new
  end
  
  def create
    @curator = Curator.new params[:curator]
    @curator.venue_id = current_venue.id
    respond_to do |format|
      format.html do
        if @curator.save
          content_for :head_js, "parent.notifyCuratorAdded(#{@curator.to_json}); parent.$.fn.colorbox.close();".html_safe # close the popup
        end
        render :action => 'new'
      end
    end
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      format.html do
        if @curator.update_attributes params[:curator]
          content_for :head_js, "parent.location.reload(); parent.$.fn.colorbox.close();".html_safe # close the popup
        end
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    respond_to do |format|
      format.html {}
      format.js do
        render :update do |page|
          if @curator.destroy   
            page.call "parent.$.fn.colorbox.close"
            page.call "parent.$('#artist_#{params[:id]}').remove"
            page.call "parent.$.sticky", '<b>Delete curator.</b><p>Curator was removed</p>'
          else
            page.call "parent.$.sticky", "<b>Delete curator.</b><p>#{@curator.errors.full_messages.join(', ')}</p>"
          end
        end
      end
    end    
  end
  
  def autocomplete
    @curators = Curator.search("*#{params[:q]}*", { :with => { :venue_id => current_venue.id } }) rescue []
    respond_to do |format|
      format.json do
        render :json => @curators.collect {|c| { :value => (c.first_name + ' ' + c.last_name), :data => { :id => c.id, :obj => c } } }.to_json
      end
    end
  end

protected

  def before_filter_curator
    @curator = Curator.find params[:id]    
  end

end
