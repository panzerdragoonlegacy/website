module LoadableForVideo
  extend ActiveSupport::Concern
  include FindBySlugConcerns

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :video).order(:name)
    ).resolve
  end

  def load_video
    @video = Video.find params[:id]
    authorize @video
  end

  def load_contributors_videos
    @contributor_profile =
      find_contributor_profile_by_slug params[:contributor_profile_id]
    @videos = policy_scope(
      Video.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_tagged_videos
    @tag = find_tag_by_slug params[:tag_id]
    @videos = policy_scope(
      Video.joins(:taggings).where(taggings: { tag_id: @tag.id }).order(:name)
        .page(params[:page])
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
