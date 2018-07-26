class ArticlesController < ApplicationController
  include LoadableForArticle

  def index
    load_categories
    if params[:contributor_profile_id]
      load_contributors_articles
    else
      @articles = policy_scope(Article.order(:name).page(params[:page]))
    end
  end

  def show
    load_article
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @article.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
