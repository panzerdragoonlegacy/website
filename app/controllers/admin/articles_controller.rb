class Admin::ArticlesController < ApplicationController
  layout 'admin'
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_article, except: [:index, :new, :create]

  def index
    @articles = policy_scope(Article.order(:name).page(params[:page]))
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

  private

  def article_params
    params.require(:article).permit(
      policy(@article || :article).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :article).order(:name)
    ).resolve
  end

  def load_article
    @article = Article.find_by url: params[:id]
    authorize @article
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
