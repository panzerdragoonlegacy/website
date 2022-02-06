class HomeController < ApplicationController
  def show
    @news_entries =
      policy_scope(NewsEntry.order('published_at desc').page(params[:page]))
  end
end
