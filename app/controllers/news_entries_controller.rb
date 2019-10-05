class NewsEntriesController < ApplicationController
  include LoadableForNewsEntry

  def index
    if params[:contributor_profile_id]
      load_contributors_news_entries
    else
      if params[:category]
        category = Category.find_by url: params[:category]
        authorize category, :show?
        @news_entries = policy_scope(
          NewsEntry.where(category: category)
            .order('published_at desc').page(params[:page])
        )
      else
        @news_entries = policy_scope(
          NewsEntry.order('published_at desc').page(params[:page])
        )
      end
    end
  end

  def show
    load_news_entry
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @news_entry.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
