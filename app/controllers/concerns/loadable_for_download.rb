module LoadableForDownload
  extend ActiveSupport::Concern
  include FindBySlugConcerns

  private

  def load_categories
    @categories =
      CategoryPolicy::Scope.new(
        current_user,
        Category.where(category_type: :download).order(:name)
      ).resolve
  end

  def load_download
    @download = Download.find params[:id]
    authorize @download
  end

  def load_contributors_downloads
    @contributor_profile =
      find_contributor_profile_by_slug(params[:contributor_profile_id])
    @downloads =
      policy_scope(
        Download
          .joins(:contributions)
          .where(
            contributions: {
              contributor_profile_id: @contributor_profile.id
            }
          )
          .order(:name)
          .page(params[:page])
      )
  end

  def load_tagged_downloads
    @tag = find_tag_by_slug params[:tag_id]
    @downloads =
      policy_scope(
        Download
          .joins(:taggings)
          .where(taggings: { tag_id: @tag.id })
          .order(:name)
          .page(params[:page])
      )
  end

  def load_draft_downloads
    @downloads =
      policy_scope(
        Download.where(publish: false).order(:name).page(params[:page])
      )
  end

  def load_category_groups
    @category_groups =
      policy_scope(
        CategoryGroup.where(category_group_type: :download).order(:name)
      )
  end
end
