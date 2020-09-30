class HomeController < ApplicationController
  def show
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
