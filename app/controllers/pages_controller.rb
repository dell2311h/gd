class PagesController < ApplicationController
  layout :with_layout?
  def show
    @page = Page.find_by_caption(params[:caption])
    require 'pp'
    pp @page
    if @page && @page.show_form?
      @message = ContactMessage.new 
      @message.page = @page
    end
    unless @page
      flash[:error] = "Page not found."
      redirect_to root_path
    end
  end
  
  def contact
    @message = ContactMessage.new params[:message]
    @page = @message.page
    if request.method != :post || !@message.save
      flash[:error] = 'You need to fill all required fields.'
    else
      ContactMailer.deliver_message(@message, @page)
      ContactMailer.deliver_sender_confirmation(@message)
      params[:message] = nil
      @message = nil
      flash[:notice] = 'Message sent.'
      flash[:error] = nil
    end
    render :action => 'show'
  end
  
  protected
    def with_layout?
      ( params[:show_layout].nil? ) ? 'application' : nil
    end
end
