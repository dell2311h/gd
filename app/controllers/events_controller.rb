class EventsController < ApplicationController
  respond_to :html
  before_filter :before_filter_find

  def show
  	search_options = {}
		search_options[:enabled] = 1
		search_options[:without] = {:close_date => Time.at(0)..Time.now.yesterday}
		search_options[:classes] = [Exhibition, Event]
		search_options[:with] = {:venue_id => @event.venue.id}
		@venue_events_exhibitions = ThinkingSphinx.search(search_options).select{|s| !s.eql?(@event) }

		  #  Changing search options to neighbourhood
		search_options[:with] = {:neighbourhood_id => @event.venue.neighbourhood_id}
    @nearby_events = ThinkingSphinx.search(search_options).select{|s| !s.eql?(@event) }
    @meta_description = @event.short_description[0..250].gsub(/<\/?[^>]*>/, "").html_safe if @event.short_description
  end

  def print
    render :layout => 'print'
  end

  def mail
    @mail = Email.new
    render 'shared/sendmail', :layout => 'popup'    
  end

  def sendmail
    @mail = Email.new params[:email]       
    
    respond_with @mail do |format|
      format.html do
        if @mail.save && @event.sendmail!(@mail)
          content_for :head_js, "parent.$.fn.colorbox.close(); parent.$.sticky('email has been sent');".html_safe
          render :inline => '', :layout => 'popup'    
        else
          render 'shared/sendmail', :layout => 'popup'    
        end
      end
    end
  end

protected

  def before_filter_find
    @event = Event.find(params[:id]) rescue nil
   
    #  Redirect if event is not found
    redirect_to(root_url) if @event.nil? 
  end

end
