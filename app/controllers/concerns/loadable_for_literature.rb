module LoadableForLiterature
  extend ActiveSupport::Concern

  private

  def load_page
    @page = Page.find_by id: params[:id]
    authorize @page
  end

  def load_contributors_literature
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @pages = policy_scope(
      Page.joins(:contributions).where(
        page_type: :literature.to_s,
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :literature).order(:name)
    )
  end
end
