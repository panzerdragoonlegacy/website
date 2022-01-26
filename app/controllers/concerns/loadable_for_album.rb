module LoadableForAlbum
  extend ActiveSupport::Concern
  include FindBySlugConcerns

  private

  def load_picture_categories
    @picture_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :picture).order(:name)
    ).resolve
  end

  def load_video_categories
    @video_categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :video).order(:name)
    ).resolve
  end

  def load_album
    @album = Album.find params[:id]
    authorize @album
  end

  def load_contributors_albums
    @contributor_profile =
      find_contributor_profile_by_slug(params[:contributor_profile_id])
    @albums = policy_scope(
      Album.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_albums
    @albums = policy_scope(
      Album.where(publish: false).order(:name).page(params[:page])
    )
  end
end
