class ArticlesController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_article, except: [:index, :new, :create]
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
      @articles = policy_scope(Article.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @articles = policy_scope(Article.order(:name).page(params[:page]))
    end
  end

  def new
    @article = Article.new
    authorize @article
  end
  
  def create
    @article = Article.new(article_params)
    authorize @article
    if @article.save
      flash[:notice] = "Successfully created article."
      params[:continue_editing] ? redirect_to(edit_article_path(@article)) : redirect_to(@article)
    else
      render :new
    end
  end
  
  def update
    params[:article][:dragoon_ids] ||= []
    if @article.update_attributes(article_params)
      flash[:notice] = "Successfully updated article."
      params[:continue_editing] ? redirect_to(edit_article_path(@article)) : redirect_to(@article)
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Successfully destroyed article."
  end
  
  private

  def article_params
    params.require(:article).permit(
      :category_id,
      :name,
      :description,
      :content,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: [],
      illustrations_attributes: [:id, :illustration, :_destroy]
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :article).order(:name)).resolve
  end

  def load_article
    @article = Article.find_by url: params[:id]
    authorize @article
  end
end
