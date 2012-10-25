class ArticlesController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @articles = Article.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Articles"
    else
      @articles = Article.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Articles"
    end
  end

  def show
    @commentable = @article
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.all
  end
  
  def create 
    @article = Article.new(params[:article])
    if @article.save
      redirect_to @article, :notice => "Successfully created article."
    else
      render 'new'
    end
  end
  
  def update
    params[:article][:dragoon_ids] ||= []
    if @article.update_attributes(params[:article])      
      redirect_to @article, :notice => "Successfully updated article."
    else
      render 'edit'
    end
  end

  def destroy    
    @article.destroy
    redirect_to articles_path, :notice => "Successfully destroyed article."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :article).order(:name)
  end
end