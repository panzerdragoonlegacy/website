module LoadableForContributorProfile
  extend ActiveSupport::Concern
  include PreviewSlugConcerns

  private

  def load_contributor_profile
    @contributor_profile =
      ContributorProfile.find_by(slug: previewless_slug(params[:id]))
    authorize @contributor_profile
  end

  def load_draft_contributor_profiles
    @contributor_profiles =
      policy_scope(
        ContributorProfile
          .where(publish: false)
          .order(:name)
          .page(params[:page])
      )
  end
end
