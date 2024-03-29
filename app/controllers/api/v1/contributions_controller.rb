class Api::V1::ContributionsController < ApplicationController
  include LoadableForPicture

  def index
    if params[:media_type] == 'pictures'
      @pictures =
        policy_scope(
          Picture
            .where(publish: true)
            .order(published_at: :desc)
            .page(params[:page])
            .per(PICTURES_PER_PAGE)
        )
    elsif params[:media_type] == 'literature'
      @pages =
        policy_scope(
          Page
            .where(page_type: :literature.to_s, publish: true)
            .order(published_at: :desc)
            .page(params[:page])
        )
    elsif params[:media_type] == 'music'
      @music_tracks =
        policy_scope(
          MusicTrack
            .where(publish: true)
            .order(published_at: :desc)
            .page(params[:page])
        )
    elsif params[:media_type] == 'videos'
      @videos =
        policy_scope(
          Video
            .where(publish: true)
            .order(published_at: :desc)
            .page(params[:page])
        )
    elsif params[:media_type] == 'downloads'
      @downloads =
        policy_scope(
          Download
            .where(publish: true)
            .order(published_at: :desc)
            .page(params[:page])
        )
    end
    render template: 'api/v1/contributions/index', formats: :json
  end
end
