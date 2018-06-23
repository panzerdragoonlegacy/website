module LoadableForLink
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :link).order(:name)
    ).resolve
  end

  def load_link
    @link = Link.find_by id: params[:id]
    authorize @link
  end

  def load_contributors_links
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @links = policy_scope(
      Link.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end
end
