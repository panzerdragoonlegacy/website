class PasswordResetsController < ApplicationController
  before_filter :load_dragoon_using_perishable_token, :only => [:edit, :update]
  
  def new
    render
  end
  
  def create
    @dragoon = Dragoon.dragoon_exists?(params[:name_or_email_address]) 
    if @dragoon
      @dragoon.create_perishable_token
      DragoonMailer.reset_password(@dragoon).deliver
      flash.now.alert = "Password reset email sent to " + @dragoon.email_address + ". Please click the link in your email."  
    else
      flash.now.alert = "Invalid name or email address. Try again."
    end
    render "new"
  end
  
  def edit
    render
  end
  
  def update
    @dragoon.password = params[:dragoon][:password]
    @dragoon.password_confirmation = params[:dragoon][:password_confirmation]
    
    # Manually validate new password. Would prefer a cleaner solution to this, 
    # but it conflicts with other model validations and validates_presence_of :password, :on => :create
    unless (params[:dragoon][:password].blank? or params[:dragoon][:password_confirmation].blank?)
      if (params[:dragoon][:password] == params[:dragoon][:password_confirmation])
        if @dragoon.save
          redirect_to root_url, :notice => "Password successfully updated"
        else
          flash.now.alert = "Could not save new password."
          render :action => :edit
        end
      else
        flash.now.alert = "Passwords don't match."
        render :action => :edit
      end
    else
      flash.now.alert = "Passwords cannot be blank."
      render :action => :edit
    end
  end
  
private
  
  def load_dragoon_using_perishable_token
    @dragoon = Dragoon.find_by_perishable_token(params[:id])
    if @dragoon
      unless @dragoon.perishable_token_expiry > Time.now
        redirect_to root_url, :notice => "Sorry, this token has expired."
      end
    else
      redirect_to root_url, :notice => "Could not validate token."
    end
  end
 
end