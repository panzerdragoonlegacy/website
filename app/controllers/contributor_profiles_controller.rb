class ContributorProfilesController < ApplicationController
  include LoadableForContributorProfile

  def show
    load_contributor_profile
  end
end
