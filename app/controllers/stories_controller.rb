class StoriesController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource
  
  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @stories = Story.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:name).page(params[:page])
      @title = @dragoon.name + "'s Stories"
    else
      @stories = Story.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Stories"
    end
  end

  def show
    @chapter_count = @story.chapters.count
    @prologues = @story.chapters.accessible_by(current_ability).where(:chapter_type => :prologue).order(:number)
    @regular_chapters = @story.chapters.accessible_by(current_ability).where(:chapter_type => :regular_chapter).order(:number)
    @epilogues = @story.chapters.accessible_by(current_ability).where(:chapter_type => :epilogue).order(:number)
    @emoticons = Emoticon.order(:name)
  end

  def create 
    @story = Story.new(params[:story])
    if @story.save
      redirect_to @story, :notice => "Successfully created story."
    else
      render 'new'
    end
  end
  
  def update
    params[:story][:dragoon_ids] ||= []  
    if @story.update_attributes(params[:story])
      redirect_to @story, :notice => "Successfully updated story."
    else
      render 'edit'
    end
  end

  def destroy    
    @story.destroy
    redirect_to stories_path, :notice => "Successfully destroyed story."
  end
  
private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :story).order(:name)
  end
end