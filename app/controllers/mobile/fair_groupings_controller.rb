class Mobile::FairGroupingsController < Mobile::MobileBaseController  
  def show
    @fair_grouping = FairGrouping.find params[:id]
    fairs = []
    @fair_grouping.fairs.each do |fair|
      fairs << { :name => fair.name, :id => fair.id }
    end
    respond_to do |format|
      format.json { render :json => { :fairs => fairs } }
    end
  end
  
end
