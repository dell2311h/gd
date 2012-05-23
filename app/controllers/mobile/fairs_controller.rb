class Mobile::FairsController < Mobile::MobileBaseController

  def show
    @fair = Fair.find params[:id]
    exhibitions = []
    @fair.fair_exhibitions.each do |f_ex|
      exhibitions << {:name => (f_ex.exhibition.title rescue f_ex.venue.name), :id => f_ex.id }
    end
    respond_to do |format|
      format.json { render :json => { :exhibitions => exhibitions }}
    end
  end
end
