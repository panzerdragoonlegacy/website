class MusicTracksController < ApplicationController
  include LoadableForMusicTrack

  def index
    if params[:contributor_profile_id]
      load_contributors_music_tracks
    elsif params[:tag_id]
      load_tagged_music_tracks
    else
      @music_tracks = policy_scope(MusicTrack.order(:name).page(params[:page]))
    end
  end

  def show
    load_music_track
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @music_track.tags.map { |tag| tag.name }).order(:name)
      ).resolve
  end
end
