class Admin::ArticlesController < ApplicationController
  include LoadableForArticle
  layout 'admin'
  before_action :load_categories, except: [:destroy]
  before_action :load_article, except: [:index, :new, :create]

  def index
    clean_publish_false_param
    @q = Article.order(:name).ransack(params[:q])
    @articles = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @article = Article.new category: category
    else
      @article = Article.new
    end
    authorize @article
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @article = Article.new article_params
    authorize @article
    if @article.save
      flash[:notice] = 'Successfully created article.'
      redirect_to_article
    else
      render :new
    end
  end

  def update
    params[:article][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @article.update_attributes article_params
      flash[:notice] = 'Successfully updated article.'
      redirect_to_article
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_articles_path, notice: 'Successfully destroyed article.'
  end

  private

  def article_params
    params.require(:article).permit(
      policy(@article || :article).permitted_attributes
    )
  end

  def redirect_to_article
    if params[:continue_editing]
      redirect_to edit_admin_article_path(@article)
    else
      redirect_to @article
    end
  end
  
  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:article][:contributor_profile_ids]
    )
      params[:article][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
