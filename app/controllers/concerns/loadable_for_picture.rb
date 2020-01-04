module LoadableForPicture
  extend ActiveSupport::Concern

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

  def load_other_pictures_in_album
    if @picture.album
      @other_pictures_in_album = PicturePolicy::Scope.new(
        current_user,
        @picture.album.pictures.where.not(id: @picture.id).order(:name)
      ).resolve
    end
  end

  def load_picture
    @picture = Picture.find_by id: params[:id]
    authorize @picture
  end

  def load_picture_to_replace
    if @picture.id_of_picture_to_replace.present?
      @picture_to_replace = Picture.find(@picture.id_of_picture_to_replace)
    end
  end

  def load_contributors_pictures
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @pictures = policy_scope(
      Picture.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
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
