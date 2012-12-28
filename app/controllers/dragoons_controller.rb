class DragoonsController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    @dragoons = Dragoon.order(:name).page(params[:page]) 
  end
  
  def show
  end

  def create
    @dragoon = Dragoon.new(params[:dragoon])
    if @dragoon.save
      session[:dragoon_id] = @dragoon.id
      if params[:stay_logged_in]
        @dragoon.create_remember_token
        cookies.permanent.signed[:remember_token] = [@dragoon.id, @dragoon.remember_token]
      end
      redirect_to root_url, :notice => "Signed up!"  
    else  
      render 'new' 
    end  
  end

  def update
    if @dragoon.update_attributes(params[:dragoon])
      redirect_to @dragoon, :notice => "Successfully updated profile."
    else
      render 'edit'
    end
  end

  def destroy    
    @dragoon.destroy
    redirect_to dragoons_path, :notice => "Successfully destroyed dragoon."
  end

end