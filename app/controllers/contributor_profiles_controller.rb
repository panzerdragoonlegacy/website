class ContributorProfilesController < ApplicationController
  include LoadableForContributorProfile

  def index
    @contributor_profiles = policy_scope(
      ContributorProfile.order(:name).page(params[:page])
    )
  end

  def show
    load_contributor_profile
  end
end
