class SessionsController < ApplicationController
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      if current_user.kind_of?(Admin)
        redirect_back_or_default backend_root_url
      elsif current_user.kind_of?(Agent)
        redirect_back_or_default '/'
      else
        redirect_back_or_default '/'
      end
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_path
  end
    
end
