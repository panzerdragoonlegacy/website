class PicturesController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource
    
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @pictures = Picture.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Pictures"
    else
      @pictures = Picture.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Pictures"
    end
  end

  def show
    @commentable = @picture
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.order(:name)
  end
  
  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      redirect_to @picture, :notice => "Successfully created picture."
    else  
      render 'new'
    end
  end
  
  def update
    if @picture.update_attributes(params[:picture])
      redirect_to @picture, :notice => "Successfully updated picture."
    else
      render 'edit'
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, :notice => "Successfully destroyed picture."
  end

private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :picture).order(:name)
  end
end