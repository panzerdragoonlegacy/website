class Redesign::VideosController < ApplicationController
  layout 'redesign'
  include LoadableForVideo

  def index
    if params[:contributor_profile_id]
      load_contributors_videos
    elsif params[:tag_id]
      load_tagged_videos
    else
      @videos = policy_scope(Video.order(:name).page(params[:page]))
    end
  end

  def show
    load_video
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @video.tags.map { |tag| tag.name }).order(:name)
      ).resolve
  end
end
