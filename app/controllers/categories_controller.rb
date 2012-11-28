class CategoriesController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def index
    @article_categories = Category.accessible_by(current_ability).where(:category_type => :article).order(:name)
    @download_categories = Category.accessible_by(current_ability).where(:category_type => :download).order(:name)
    @encyclopaedia_entry_categories = Category.accessible_by(current_ability).where(:category_type => :encyclopaedia_entry).order(:name)
    @link_categories = Category.accessible_by(current_ability).where(:category_type => :link).order(:name)
    @music_track_categories = Category.accessible_by(current_ability).where(:category_type => :music_track).order(:name)
    @picture_categories = Category.accessible_by(current_ability).where(:category_type => :picture).order(:name)
    @resource_categories = Category.accessible_by(current_ability).where(:category_type => :resource).order(:name)
    @story_categories = Category.accessible_by(current_ability).where(:category_type => :story).order(:name)
    @video_categories = Category.accessible_by(current_ability).where(:category_type => :video).order(:name)
  end

  def show
    @articles = Article.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @downloads = Download.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @encyclopaedia_entries = EncyclopaediaEntry.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @links = Link.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @music_tracks = MusicTrack.accessible_by(current_ability).where(:category_id => @category.id).order(:track_number).order(:name).page(params[:page])
    @pictures = Picture.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @resources = Resource.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @stories = Story.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
    @videos = Video.accessible_by(current_ability).where(:category_id => @category.id).order(:name).page(params[:page])
  end
  
  def create  
    @category = Category.new(params[:category])
    if @category.save
      redirect_to @category, :notice => "Successfully created category."
    else  
      render 'new'
    end
  end
  
  def update
    if @category.update_attributes(params[:category])
      redirect_to @category, :notice => "Successfully updated category."
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, :notice => "Successfully destroyed category."
  end
end