module Admin::HistoryHelper
  def link_to_contributor_profile(user_id)
    user = User.where(id: user_id).first
    if user&.contributor_profile
      link_to(
        user.contributor_profile.name,
        contributor_profile_path(user.contributor_profile)
      )
    else
      'Unknown Contributor'
    end
  end
end
