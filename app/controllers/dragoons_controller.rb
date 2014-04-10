class DragoonsController < ApplicationController
  
  def index
    @dragoons = policy_scope(Dragoon.order(:name).page(params[:page]))
  end
  
  def show
    @dragoon = Dragoon.find_by_url(params[:id])
    authorize @dragoon
  end

  def new
    @dragoon = Dragoon.new
    authorize @dragoon
  end

  def create
    @dragoon = Dragoon.new(params[:dragoon])
    authorize @dragoon
    if @dragoon.save
      session[:dragoon_id] = @dragoon.id
      if params[:stay_logged_in]
        @dragoon.create_remember_token
        cookies.permanent.signed[:remember_token] = [@dragoon.id, @dragoon.remember_token]
      end
      redirect_to root_url, notice: "Signed up!"  
    else  
      render :new 
    end  
  end

  def edit
    @dragoon = Dragoon.find_by_url(params[:id])
    authorize @dragoon
  end

  def update
    @dragoon = Dragoon.find_by_url(params[:id])
    authorize @dragoon
    if @dragoon.update_attributes(params[:dragoon])
      redirect_to @dragoon, notice: "Successfully updated profile."
    else
      render :edit
    end
  end

  def destroy
    @dragoon = Dragoon.find_by_url(params[:id])
    authorize @dragoon
    @dragoon.destroy
    redirect_to dragoons_path, notice: "Successfully destroyed dragoon."
  end

end
