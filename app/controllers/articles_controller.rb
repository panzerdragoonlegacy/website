class ArticlesController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @articles = policy_scope(Article.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @articles = policy_scope(Article.order(:name).page(params[:page]))
    end
  end

  def show
    @article = Article.find_by_url(params[:id])
    authorize @article
  end

  def new
    @article = Article.new
    authorize @article
  end
  
  def create 
    @article = Article.new(params[:article])
    authorize @article
    if @article.save
      redirect_to @article, notice: "Successfully created article."
    else
      render :new
    end
  end

  def edit
    @article = Article.find_by_url(params[:id])
    authorize @article
  end
  
  def update
    @article = Article.find_by_url(params[:id])
    authorize @article
    params[:article][:dragoon_ids] ||= []
    if @article.update_attributes(params[:article])      
      redirect_to @article, notice: "Successfully updated article."
    else
      render :edit
    end
  end

  def destroy
    @article = Article.find_by_url(params[:id])
    authorize @article
    @article.destroy
    redirect_to articles_path, notice: "Successfully destroyed article."
  end
  
  private

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :article).order(:name)).resolve
  end

end
