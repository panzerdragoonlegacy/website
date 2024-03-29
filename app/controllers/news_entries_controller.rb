class NewsEntriesController < ApplicationController
  include LoadableForNewsEntry

  def index
    if params[:contributor_profile_id]
      load_contributors_news_entries
    elsif params[:tag_id]
      load_tagged_news_entries
    elsif params[:year]
      load_news_entries_for_year
    else
      load_news_entry_years
      load_news_entries_for_atom_feed
    end
  end

  def show
    load_news_entry
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @news_entry.tags.map { |tag| tag.name }).order(:name)
      ).resolve
  end
end
