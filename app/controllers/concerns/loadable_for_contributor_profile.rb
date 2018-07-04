module LoadableForContributorProfile
  extend ActiveSupport::Concern

  private

  def load_contributor_profile
    @contributor_profile = ContributorProfile.find_by url: params[:id]
    authorize @contributor_profile
  end

  def load_draft_contributor_profiles
    @contributor_profiles = policy_scope(
      ContributorProfile.where(publish: false).order(:name).page(params[:page])
    )
  end
end
