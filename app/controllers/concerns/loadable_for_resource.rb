module LoadableForResource
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :resource).order(:name)
    ).resolve
  end

  def load_resource
    @resource = Resource.find params[:id]
    authorize @resource
  end

  def load_contributors_resources
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @resources = policy_scope(
      Resource.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_resources
    @resources = policy_scope(
      Resource.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :resource).order(:name)
    )
  end
end
