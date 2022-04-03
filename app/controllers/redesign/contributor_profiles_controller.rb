class Redesign::ContributorProfilesController < ApplicationController
  layout 'redesign'
  include LoadableForContributorProfile

  def show
    load_contributor_profile
  end
end
