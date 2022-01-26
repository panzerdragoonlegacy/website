module LoadableForPicture
  extend ActiveSupport::Concern
  include FindBySlugConcerns

  private

  def load_replaceable_pictures
    @replaceable_pictures = PicturePolicy::Scope.new(
      current_user,
      Picture.where(publish: true).order(:name)
    ).resolve
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :picture).order(:name)
    ).resolve
  end

  def load_picture
    @picture = Picture.find params[:id]
    authorize @picture
  end

  def load_picture_to_replace
    if @picture.id_of_picture_to_replace.present?
      @picture_to_replace = Picture.find(@picture.id_of_picture_to_replace)
    end
  end

  def load_contributors_pictures
    @contributor_profile =
      find_contributor_profile_by_slug params[:contributor_profile_id]
    @pictures = policy_scope(
      Picture.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
    @group_pictures_into_albums = false
  end

  def load_tagged_pictures
    @tag = find_tag_by_slug params[:tag_id]
    @pictures = policy_scope(
      Picture.joins(:taggings).where(taggings: { tag_id: @tag.id }).order(:name)
        .page(params[:page])
    )
  end

  def load_draft_pictures
    @pictures = policy_scope(
      Picture.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :picture).order(:name)
    )
  end
end
