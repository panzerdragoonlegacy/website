module LoadableForShare
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :share).order(:name)
    ).resolve
  end

  def load_share
    @share = Share.find_by id: params[:id]
    authorize @share
  end

  def load_contributors_shares
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @shares = policy_scope(
      Share.where(contributor_profile_id: @contributor_profile.id)
        .order('created_at desc').page(params[:page])
    )
  end
end
