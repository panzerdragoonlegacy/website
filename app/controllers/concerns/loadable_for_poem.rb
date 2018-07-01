module LoadableForPoem
  extend ActiveSupport::Concern

  private

  def load_poem
    @poem = Poem.find_by url: params[:id]
    authorize @poem
  end

  def load_contributors_poems
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @poems = policy_scope(
      Poem.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_poems
    @poems = policy_scope(
      Poem.where(publish: false).order(:name).page(params[:page])
    )
  end
end
