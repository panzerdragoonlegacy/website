class ArticlesController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_article, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      unless @contributor_profile = ContributorProfile.find_by(
        url: params[:contributor_profile_id])
        raise "Contributor profile not found."
      end  
      @articles = policy_scope(Article.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }).
        order(:name).page(params[:page]))
    elsif params[:drafts]
      @articles = policy_scope(Article.where(publish: false).order(:name).
        page(params[:page]))
    else
      @articles = policy_scope(Article.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(current_user,
      @article.encyclopaedia_entries.order(:name)).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise "Category not found." unless category.present?
      @article = Article.new category: category
    else
      @article = Article.new
    end
    authorize @article
  end

  def create
    @article = Article.new article_params
    authorize @article
    if @article.save
      flash[:notice] = "Successfully created article."
      if params[:continue_editing]
        redirect_to edit_article_path(@article)
      else
        redirect_to @article
      end
    else
      render :new
    end
  end

  def update
    params[:article][:contributor_profile_ids] ||= []
    if @article.update_attributes article_params
      flash[:notice] = "Successfully updated article."
      if params[:continue_editing]
        redirect_to edit_article_path(@article)
      else
        redirect_to @article
      end
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
      policy(@article || :article).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :article).order(:name)).resolve
  end

  def load_article
    @article = Article.find_by url: params[:id]
    authorize @article
  end
end
