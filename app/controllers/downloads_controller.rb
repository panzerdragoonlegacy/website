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
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @download.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
