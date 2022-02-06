module LoadableForLiterature
  extend ActiveSupport::Concern
  include FindBySlugConcerns

  private

  def load_literature_page
    @page = Page.where(id: params[:id], page_type: :literature.to_s).first
    authorize @page
  end

  def load_contributors_literature
    @contributor_profile =
      find_contributor_profile_by_slug(params[:contributor_profile_id])
    @pages =
      policy_scope(
        Page
          .joins(:contributions)
          .where(
            page_type: :literature.to_s,
            contributions: {
              contributor_profile_id: @contributor_profile.id
            }
          )
          .order(:name)
          .page(params[:page])
      )
  end

  def load_tagged_literature
    @tag = find_tag_by_slug params[:tag_id]
    @pages =
      policy_scope(
        Page
          .joins(:taggings)
          .where(taggings: { tag_id: @tag.id })
          .order(:name)
          .page(params[:page])
      )
  end

  def load_category_groups
    @category_groups =
      policy_scope(
        CategoryGroup.where(category_group_type: :literature).order(:name)
      )
  end
end
