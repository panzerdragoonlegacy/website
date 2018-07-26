class MusicTracksController < ApplicationController
  include LoadableForMusicTrack

  def index
    if params[:contributor_profile_id]
      load_contributors_music_tracks
    else
      load_category_groups
      @music_tracks = policy_scope(MusicTrack.order(:name).page(params[:page]))
    end
  end

  def show
    load_music_track
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @music_track.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
