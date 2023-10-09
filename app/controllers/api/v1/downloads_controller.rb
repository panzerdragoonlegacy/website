class Api::V1::DownloadsController < ApplicationController
  include LoadableForDownload

  def index
    if params[:contributor_profile_id]
      load_contributors_downloads
    elsif params[:tag_id]
      load_tagged_downloads
    else
      @downloads = policy_scope(Download.order(:name).page(params[:page]))
    end
    render template: 'api/v1/downloads/index', formats: :json
  end

  def show
    load_download
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @download.tags.map { |tag| tag.name }).order(:name)
      ).resolve
    render template: 'api/v1/downloads/show', formats: :json
  end
end
