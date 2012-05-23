class Mobile::MobileBaseController < ApplicationController
  layout nil
  
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
  
  protected
      def user_required
  
      end

      def venue_required
  
      end

  
      def static_pages
  
      end

      def region_options
  
      end

      def invitation_handler
  
      end
  
end
