class VideosController < ApplicationController
  include LoadableForVideo

  def index
    if params[:contributor_profile_id]
      load_contributors_videos
    else
      load_category_groups
      @videos = policy_scope(Video.order(:name).page(params[:page]))
    end
  end

  def show
    load_video
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @video.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
