class DragoonsController < ApplicationController
  before_action :load_dragoon, except: [:index, :new, :create]

  def index
    @dragoons = policy_scope(Dragoon.order(:name).page(params[:page]))
  end

  def new
    @dragoon = Dragoon.new
    authorize @dragoon
  end

  def create
    @dragoon = Dragoon.new(dragoon_params)
    authorize @dragoon
    if @dragoon.save
      redirect_to @dragoon, notice: "Successfully created dragoon profile."
    else
      render :new
    end
  end

  def update
    if @dragoon.update_attributes(dragoon_params)
      flash[:notice] = "Successfully updated dragoon profile."
      if params[:continue_editing]
        redirect_to edit_dragoon_path(@dragoon)
      else
        redirect_to @dragoon
      end
    else
      render :edit
    end
  end

  def destroy
    @dragoon.destroy
    redirect_to dragoons_path, notice: "Successfully destroyed dragoon profile."
  end

  private

  def dragoon_params
    params.require(:dragoon).permit(
      :name,
      :email_address,
      :discourse_username,
      :avatar,
      :website,
      :facebook_username,
      :twitter_username
    )
  end

  def load_dragoon
    @dragoon = Dragoon.find_by url: params[:id]
    authorize @dragoon
  end
end
