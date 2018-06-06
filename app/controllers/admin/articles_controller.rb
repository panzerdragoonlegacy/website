class Admin::ArticlesController < ApplicationController
  layout 'admin'
  
  def index
    @articles = policy_scope(Article.order(:name).page(params[:page]))
  end
end
