module LoadableForStory
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :story).order(:name)
    ).resolve
  end

  def load_story
    @story = Story.find_by url: params[:id]
    authorize @story
  end

  def load_contributors_stories
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @stories = policy_scope(
      Story.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_stories
    @stories = policy_scope(
      Story.where(publish: false).order(:name).page(params[:page])
    )
  end
end
