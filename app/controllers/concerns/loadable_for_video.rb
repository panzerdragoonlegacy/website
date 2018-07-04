module LoadableForVideo
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :video).order(:name)
    ).resolve
  end

  def load_video
    @video = Video.find_by id: params[:id]
    authorize @video
  end

  def load_contributors_videos
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @videos = policy_scope(
      Video.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_videos
    @videos = policy_scope(
      Video.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :video).order(:name)
    )
  end
end
