module LoadableForArticle
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :article).order(:name)
    ).resolve
  end

  def load_article
    @article = Article.find_by url: params[:id]
    authorize @article
  end

  def load_contributors_articles
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @articles = policy_scope(
      Article.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_articles
    @articles = policy_scope(
      Article.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :article).order(:name)
    )
  end
end
