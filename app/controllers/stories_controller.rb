class StoriesController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @stories = policy_scope(Story.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @stories = policy_scope(Story.order(:name).page(params[:page]))
    end
  end

  def show
    @story = Story.find_by_url(params[:id])
    authorize @story
    
    @chapter_count = ChapterPolicy::Scope.new(current_user, @story.chapters).resolve.count
    @prologues = ChapterPolicy::Scope.new(current_user, @story.chapters.where(chapter_type: :prologue).order(:number)).resolve
    @regular_chapters = ChapterPolicy::Scope.new(current_user, @story.chapters.where(chapter_type: :regular_chapter).order(:number)).resolve
    @epilogues = ChapterPolicy::Scope.new(current_user, @story.chapters.where(chapter_type: :epilogue).order(:number)).resolve
  end

  def new
    @story = Story.new
    authorize @story
  end

  def create 
    @story = Story.new(params[:story])
    authorize @story
    if @story.save
      redirect_to @story, notice: "Successfully created story."
    else
      render :new
    end
  end
  
  def edit
    @story = Story.find_by_url(params[:id])
    authorize @story
  end

  def update
    @story = Story.find_by_url(params[:id])
    authorize @story
    params[:story][:dragoon_ids] ||= []
    if @story.update_attributes(params[:story])      
      redirect_to @story, notice: "Successfully updated story."
    else
      render :edit
    end
  end

  def destroy    
    @story.destroy
    authorize @story
    redirect_to stories_path, notice: "Successfully destroyed story."
  end
  
  private

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :story).order(:name)).resolve
  end

end
