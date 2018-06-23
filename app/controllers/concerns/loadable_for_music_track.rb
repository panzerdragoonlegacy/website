module LoadableForMusicTrack
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :music_track).order(:name)
    ).resolve
  end

  def load_music_track
    @music_track = MusicTrack.find_by id: params[:id]
    authorize @music_track
  end

  def load_contributors_music_tracks
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @music_tracks = policy_scope(
      MusicTrack.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_music_tracks
    @music_tracks = policy_scope(
      MusicTrack.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :music_track).order(:name)
    )
  end
end
