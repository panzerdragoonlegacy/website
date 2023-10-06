class Api::V1::ContributorProfilesController < ApplicationController
  include LoadableForContributorProfile

  def show
    load_contributor_profile
    render template: 'api/v1/contributor_profiles/show', formats: :json
  end
end
