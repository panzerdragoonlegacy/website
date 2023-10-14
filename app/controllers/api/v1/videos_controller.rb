class Api::V1::VideosController < ApplicationController
  include LoadableForVideo

  def index
    if params[:contributor_profile_id]
      load_contributors_videos
    elsif params[:tag_id]
      load_tagged_videos
    else
      @videos = policy_scope(Video.order(:name).page(params[:page]))
    end
    render template: 'api/v1/videos/index', formats: :json
  end

  def show
    load_video
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @video.tags.map { |tag| tag.name }).order(:name)
      ).resolve
    render template: 'api/v1/videos/show', formats: :json
  end
end
