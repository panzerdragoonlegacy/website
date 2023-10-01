class Api::V1::NewsEntriesController < ApplicationController
  include LoadableForNewsEntry

  def index
    if params[:contributor_profile_id]
      load_contributors_news_entries
    elsif params[:tag_id]
      load_tagged_news_entries
    elsif params[:year]
      load_news_entries_for_year
    end
    render template: 'api/v1/news_entries/index', formats: :json
  end

  def show
    load_news_entry
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @news_entry.tags.map { |tag| tag.name }).order(:name)
      ).resolve
    render template: 'api/v1/news_entries/show', formats: :json
  end
end
