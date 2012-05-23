class VenueManager::ImagesController < VenueManager::VenueManagerBaseController
  respond_to :html, :json, :js
  
  def index
    @images = case params[:filter]
      when nil: ( (params[:search].blank?) ? current_venue.related_images.all : (Image.search("*#{params[:search]}*", :with_all => { :venue_id => current_venue.id }, :match_mode => :boolean) rescue []) )
      else Image.search("*#{params[:search]}* #{params[:filter]}", :with_all => { :venue_id => current_venue.id }, :match_mode => :boolean) rescue []
    end
    @image_counter = {}
    @image_counter[:all] =  current_venue.related_images.count
    Image::KINDS.each_pair { |key, value| @image_counter[key] = Image.search_count value, :with_all => { :venue_id => current_venue.id }, :match_mode => :boolean }
  end
  
  def show
    @image = Image.find(params[:id])
    respond_to do |format|
      format.json { render :json => { :image => @image, :small_url => @image.file.url(:small) } }
    end
  end
  
  def new
    @image = Image.new
    @image.kind = params[:image][:kind] rescue nil
    @default_image = params[:default] || false rescue false
    # html only
  end

  def upload
    @image = Image.new params[:image]
    @image.venue_id = current_venue.id
    @image.file_content_type = MIME::Types.type_for(@image.file_file_name).to_s

    respond_with(@image) do |format|
      format.json { render :json => {:urls => @image.urls_object.to_json, :id => @image.id} } if @image.save
      format.any { render :nothing => true }
    end
  end
 
  def create
    @image = Image.find(params[:image][:id]) rescue Image.new
    default_image = params[:default_image] == '1' rescue false
    respond_to do |format|
      if @image.update_attributes(params[:image])
        #  For compatibility with _form.hrml.erb use {:image => our image attributes plus default_image value}
        images_json = {:image => @image.attributes.merge({:default_image => default_image})}.to_json
        format.html do
          content_for :head_js, "parent.$.fn.colorbox.close(); parent.notifyImageAdded(#{images_json}, #{@image.urls_object.to_json});".html_safe
          render :inline => '', :layout => 'popup' 
        end
        format.json { render :json => @image.to_json }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @image.errors.full_messages }
      end
    end
  end
  
  def edit
    @image = Image.find(params[:id])
    respond_to do |format|
      format.html {}
      format.json { render :json => @image.to_json }
    end
  end
  
  def update
    @image = Image.find(params[:id])
    if @image.update_attributes params[:image]
      @image['popup_caption'] = @image.popup_caption
      content_for :head_js, "parent.$.fn.colorbox.close(); parent.notifyImageChanged(#{@image.to_json}, #{@image.urls_object.to_json});".html_safe
    end
    render :action => 'edit'
  end
  
  def destroy
    if params[:id].kind_of?(Array)
      @images = Image.find(params[:id])
      @images.each do |image|
        image.destroy
      end
    else
      @image = Image.find(params[:id])
      @image.destroy
    end
    
    respond_to do |format|
      format.html {}
      format.js do
        render :update do |page|
          if @image.errors.empty?
            id = (params[:id].kind_of?(Array)) ? params[:id].collect {|i| "#image_#{i}"}.join(' ') : "#image_#{params[:id]}"
            page.call "$('#{id}').remove"
            page.call "$.sticky", '<b>Delete image.</b><p>Image was removed</p>'
          else
            page.call "$.sticky", "<b>Delete image.</b><p>#{@image.errors.full_messages.join(', ')}</p>"
          end
        end
      end
    end
  end
  
  def autocomplete
    kinds = params[:kind].split(',')
    kinds_str = (kinds.empty?) ? '' : '(@kind ' + kinds.join(') | (@kind ') + ')'
    @images = Image.search("*#{params[:q]}* #{kinds_str}", :with_all => { :venue_id => current_venue.id }, :match_mode => :boolean) rescue []
    respond_to do |format|
      format.json do
        render :json => @images.collect {|a| { :value => a.file_file_name, :data => { :id => a.id, :image => a, :urls => a.urls_object } } }.to_json
      end
    end
  end
  
end
