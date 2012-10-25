class VideosController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource
    
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @videos = Video.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Videos"
    else
      @videos = Video.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Videos"
    end
  end

  def show
    @commentable = @video
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.order(:name)
  end
  
  def create 
    @video = Video.new(params[:video])
    if @video.save
      redirect_to @video, :notice => "Successfully created video."
    else
      render 'new'
    end
  end
  
  def update
    params[:video][:dragoon_ids] ||= []  
    if @video.update_attributes(params[:video])
      redirect_to @video, :notice => "Successfully updated video."
    else
      render 'edit'
    end
  end

  def destroy    
    @video.destroy
    redirect_to videos_path, :notice => "Successfully destroyed video."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :video).order(:name)
  end
end