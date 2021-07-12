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
    @tags = TagPolicy::Scope.new(
      current_user,
      Tag.where(name: @news_entry.tags.map { |tag| tag.name }).order(:name)
    ).resolve
  end

  private

  def load_news_entries_for_year
    year = params[:year].to_i
    year_start_time = Time.utc(year, 1, 1)
    year_end_time = Time.utc(year, 12, 31, 11, 59, 59)
    @news_entries = policy_scope(
      NewsEntry.where(published_at: (year_start_time..year_end_time))
        .order('published_at desc')
        .page(params[:page])
    )
  end

  def newest_news_entry_year
    news_entry = NewsEntry.where(publish: true).order(:published_at).last
    news_entry ? news_entry.published_at.year : nil
  end

  def oldest_news_entry_year
    news_entry = NewsEntry.where(publish: true).order(:published_at).first
    news_entry ? news_entry.published_at.year : nil
  end

  def load_news_entry_years
    @news_entry_years = []
    first_year = newest_news_entry_year
    last_year = oldest_news_entry_year
    if first_year && last_year
      year = first_year
      while year >= last_year do
        @news_entry_years << year
        year = year - 1
      end
    end
  end

  def load_news_entries_for_atom_feed
    @news_entries = policy_scope(
      NewsEntry.order('published_at desc').page(params[:page])
    )
  end
end
