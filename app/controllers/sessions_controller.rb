class SessionsController < ApplicationController
  after_action :verify_authorized, except: [:new, :create, :destroy]

  def new
  end
    
  def create
    dragoon = Dragoon.authenticate(params[:name_or_email_address], params[:password])
    if dragoon
      if params[:stay_logged_in]
        dragoon.create_remember_token
        cookies.permanent.signed[:remember_token] = [dragoon.id, dragoon.remember_token]
      end
      session[:dragoon_id] = dragoon.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid name, email address, or password."
      render "new"
    end
  end

  def destroy
    cookies.delete(:remember_token)
    session[:dragoon_id] = nil
    redirect_to root_url, :notice => "Logged out!"  
  end
end
