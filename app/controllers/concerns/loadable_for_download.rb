module LoadableForDownload
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :download).order(:name)
    ).resolve
  end

  def load_download
    @download = Download.find_by id: params[:id]
    authorize @download
  end

  def load_contributors_downloads
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @downloads = policy_scope(
      Download.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_downloads
    @downloads = policy_scope(
      Download.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :download).order(:name)
    )
  end
end
