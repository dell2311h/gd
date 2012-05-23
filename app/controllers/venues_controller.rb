class VenuesController < ApplicationController
  respond_to :html
  before_filter :before_filter_find, :only => [:show, :print, :sendmail]

  
  def show
    @venue_events_exhibitions = ThinkingSphinx.search :with =>  { :venue_id => params[:id] },
      :enabled => 1,      
      :without => { :close_date => Time.at(0)..Time.now.yesterday },
      :classes => [Exhibition, Event]

    @past_venues = ThinkingSphinx.search  :with =>  { :venue_id => params[:id], :close_date => Time.at(0)..Time.now.yesterday },
      :enabled => 1,      
      :classes =>  [Exhibition, Event]
  end
  
  def new
    @venue = Venue.new
    render 'new', :layout => 'popup'    
  end
  
  def create
    @venue = Venue.new params[:venue]
    @venue.gallery_type = params[:gallery_type]

    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @venue.save_without_session_maintenance
      @venue.deliver_activation_instructions!
      flash[:notice] = "<b>Your account has been created. Please check your e-mail for your account activation instructions!</b>"
      content_for :head_js, "parent.$.fn.colorbox.close(); parent.location.reload();".html_safe
      render :new, :layout => 'popup'
    else
      flash[:notice] = "<b>Sorry, but your account hasn't been created.</b><br /><p>#{@venue.errors.full_messages.join('<br /><br />')}</p>"
      render :new, :layout => 'popup'
    end
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
        if @mail.save && @venue.sendmail!(@mail)
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
    @venue = Venue.find(params[:id]) rescue nil
   
    #  Redirect if event is not found
    redirect_to(root_url) if @venue.nil? 
  end


end
