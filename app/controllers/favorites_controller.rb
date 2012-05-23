class FavoritesController < ApplicationController
  before_filter :user_required
  
  def index
    @favorites = current_user.favorites
    @venues = @favorites.map(&:item).paginate :per_page => 10, :page => params[:page]
  end
  
  def create
    @favorite = Favorite.new
    @favorite.favorite_id = params[:venue_id]
    unless current_user.favorites.map(&:favorite_id).include?(params[:venue_id].to_i)
      current_user.favorites << @favorite
    end
    unless params[:itineraries].nil? or params[:itineraries].empty?
      current_user.itineraries.find(params[:itineraries]).each do |i|
        i.favorites << @favorite
      end
    end
    render :update do |page|
      @favorite.item.exhibitions.each do |ex|
        page.replace "star_block_#{@favorite.favorite_id}_#{ex.id}", :partial => 'shared/star_icon', :locals => { :venue => @favorite.item, :big_star => params[:big_star], :exhibition => ex }
      end
      page.call "jQuery.modal.close"
      page.replace "star_block_#{params[:block_id]}", :partial => 'shared/star_icon', :locals => { :venue => @favorite.item, :big_star => params[:big_star], :suffix => params[:suffix], :exhibition => (Exhibition.find(params[:exhibition_id]) rescue nil) }
      page.call "jQuery('#star_block_multiple_update_#{params[:block_id]}').modal"
    end
  end
  
  def destroy
    @favorite = current_user.favorites.find(:all, :conditions => ['favorite_id = ?', params[:id]]).first
    @venue = @favorite.item rescue Venue.new # tmp fix for already deleted venues present in itineraries
    @favorite.destroy rescue ''
    respond_to do |format|
      format.js do
        render :update do |page|
          @venue.exhibitions.each do |ex|
            page.replace "star_block_#{@venue.id}_#{ex.id}", :partial => 'shared/star_icon', :locals => { :venue => @venue, :big_star => params[:big_star], :exhibition => ex }
          end
          page.call "jQuery.modal.close"
        end
      end
      format.html do
        flash[:notice] = "'#{@venue.name}' was removed from favorites."
        redirect_to user_favorites_path(current_user)
      end
    end
  end
end
