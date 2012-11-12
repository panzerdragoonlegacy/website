class EncyclopaediaEntriesController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource

  def index
    @encyclopaedia_entries = EncyclopaediaEntry.accessible_by(current_ability).order(:name).page(params[:page]) 
  end

  def show
    @articles = @encyclopaedia_entry.articles.accessible_by(current_ability).order(:name)
    @downloads = @encyclopaedia_entry.downloads.accessible_by(current_ability).order(:name)
    @links = @encyclopaedia_entry.links.accessible_by(current_ability).order(:name)
    @music_tracks = @encyclopaedia_entry.music_tracks.accessible_by(current_ability).order(:name)
    @pictures = @encyclopaedia_entry.pictures.accessible_by(current_ability).order(:name)
    @poems = @encyclopaedia_entry.poems.accessible_by(current_ability).order(:name)
    @quizzes = @encyclopaedia_entry.quizzes.accessible_by(current_ability).order(:name)
    @resources = @encyclopaedia_entry.resources.accessible_by(current_ability).order(:name)
    @stories = @encyclopaedia_entry.stories.accessible_by(current_ability).order(:name)
    @videos = @encyclopaedia_entry.videos.accessible_by(current_ability).order(:name)
  end

  def create 
    @encyclopaedia_entry = EncyclopaediaEntry.new(params[:encyclopaedia_entry])
    if @encyclopaedia_entry.save
      redirect_to @encyclopaedia_entry, :notice => "Successfully created encyclopaedia entry."
    else
      render 'new'
    end
  end

  def update
    params[:encyclopaedia_entry][:article_ids] ||= []
    params[:encyclopaedia_entry][:download_ids] ||= []
    params[:encyclopaedia_entry][:link_ids] ||= []
    params[:encyclopaedia_entry][:music_track_ids] ||= []
    params[:encyclopaedia_entry][:picture_ids] ||= []
    params[:encyclopaedia_entry][:poem_ids] ||= []
    params[:encyclopaedia_entry][:quiz_ids] ||= []
    params[:encyclopaedia_entry][:resource_ids] ||= []
    params[:encyclopaedia_entry][:story_ids] ||= []
    params[:encyclopaedia_entry][:video_ids] ||= []
    if @encyclopaedia_entry.update_attributes(params[:encyclopaedia_entry])
      redirect_to @encyclopaedia_entry, :notice => "Successfully updated encyclopaedia entry."
    else
      render 'edit'
    end
  end

  def destroy    
    @encyclopaedia_entry.destroy
    redirect_to encyclopaedia_entries_path, :notice => "Successfully destroyed encyclopaedia entry."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :encyclopaedia_entry).order(:name)
  end
end