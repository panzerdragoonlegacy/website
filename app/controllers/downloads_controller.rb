class DownloadsController < ApplicationController
  include LoadableForDownload

  def index
    if params[:contributor_profile_id]
      load_contributors_downloads
    else
      load_category_groups
      @downloads = policy_scope(Download.order(:name).page(params[:page]))
    end
  end

  def show
    load_download
    @tags = TagPolicy::Scope.new(
      current_user,
      Tag.where(name: @download.tags.map { |tag| tag.name }).order(:name)
    ).resolve
  end
end
