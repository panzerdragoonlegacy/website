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
      @article.encyclopaedia_entries.order(:name)
    ).resolve
  end
end
