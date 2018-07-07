class NewsEntriesController < ApplicationController
  include LoadableForNewsEntry

  def index
    if params[:contributor_profile_id]
      load_contributors_news_entries
    else
      @news_entries = policy_scope(
        NewsEntry.order('published_at desc').page(params[:page])
      )
    end
  end

  def show
    load_news_entry
  end
end
