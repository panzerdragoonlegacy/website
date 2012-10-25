class DownloadsController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @downloads = Download.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Downloads"
    else
      @downloads = Download.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Downloads"
    end
  end

  def show
    @commentable = @download
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.order(:name)
  end

  def create 
    @download = Download.new(params[:download])
    if @download.save
      redirect_to @download, :notice => "Successfully created download."
    else
      render 'new'
    end
  end
  
  def update
    params[:download][:dragoon_ids] ||= []  
    if @download.update_attributes(params[:download])
      redirect_to @download, :notice => "Successfully updated download."
    else
      render 'edit'
    end
  end

  def destroy    
    @download.destroy
    redirect_to downloads_path, :notice => "Successfully destroyed download."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :download).order(:name)
  end
end