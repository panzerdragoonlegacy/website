class UsersController < ApplicationController
  before_action :load_user, except: [:index]

  def index
    @users = policy_scope(User.order(:email).page(params[:page]))
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "Successfully updated user."
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "Successfully destroyed user."
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :administrator
    )
  end

  def load_user
    @user = User.find params[:id]
    authorize @user
  end
end