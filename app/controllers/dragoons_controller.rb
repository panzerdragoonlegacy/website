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

  def update
    if @dragoon.update_attributes(dragoon_params)
      flash[:notice] = "Successfully updated profile."
      params[:continue_editing] ? redirect_to(edit_dragoon_path(@dragoon)) : redirect_to(@dragoon)
    else
      render :edit
    end
  end

  def destroy
    @dragoon.destroy
    redirect_to dragoons_path, notice: "Successfully destroyed dragoon."
  end

  private

  def dragoon_params
    params.require(:dragoon).permit(
      :name,
      :email_address,
      :password,
      :password_confirmation,
      :forum_member_id,
      :time_zone,
      :role,
      :avatar,
      :birthday,
      :gender,
      :country,
      :information,
      :favourite_quotations,
      :occupation,
      :interests,
      :website,
      :facebook_username,
      :twitter_username,
      :xbox_live_gamertag,
      :playstation_network_online_id,
      :wii_number,
      :steam_username,
      :windows_live_id,
      :yahoo_id,
      :aim_screenname,
      :icq_number,
      :jabber_id,
      :skype_name
    )
  end

  def load_dragoon
    @dragoon = Dragoon.find_by url: params[:id]
    authorize @dragoon
  end
end
