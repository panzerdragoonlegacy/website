class ContributorProfilesController < ApplicationController
  before_action :load_contributor_profile, except: [:index, :new, :create]

  def index
    @contributor_profiles = policy_scope(ContributorProfile.order(:name).page(
      params[:page]))
  end

  def new
    @contributor_profile = ContributorProfile.new
    authorize @contributor_profile
  end

  def create
    @contributor_profile = ContributorProfile.new(contributor_profile_params)
    authorize @contributor_profile
    if @contributor_profile.save
      redirect_to(@contributor_profile, 
        notice: "Successfully created contributor profile.")
    else
      render :new
    end
  end

  def update
    if @contributor_profile.update_attributes(contributor_profile_params)
      flash[:notice] = "Successfully updated contributor profile."
      if params[:continue_editing]
        redirect_to edit_contributor_profile_path(@contributor_profile)
      else
        redirect_to @contributor_profile
      end
    else
      render :edit
    end
  end

  def destroy
    @contributor_profile.destroy
    redirect_to(contributor_profiles_path, 
      notice: "Successfully destroyed contributor profile.")
  end

  private

  def contributor_profile_params
    params.require(:contributor_profile).permit(
      :name,
      :email_address,
      :discourse_username,
      :avatar,
      :website,
      :facebook_username,
      :twitter_username
    )
  end

  def load_contributor_profile
    @contributor_profile = ContributorProfile.find_by url: params[:id]
    authorize @contributor_profile
  end
end
