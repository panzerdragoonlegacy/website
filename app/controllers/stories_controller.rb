class StoriesController < ApplicationController

  before_action :load_categories, except: [:show, :destroy]
  before_action :load_story, except: [:index, :new, :create]
    
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
      @stories = policy_scope(Story.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @stories = policy_scope(Story.order(:name).page(params[:page]))
    end
  end

  def show    
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
    @story = Story.new(story_params)
    authorize @story
    if @story.save
      flash[:notice] = "Successfully created story."
      params[:continue_editing] ? redirect_to(edit_story_path(@story)) : redirect_to(@story)
    else
      render :new
    end
  end
  
  def update
    params[:story][:dragoon_ids] ||= []
    if @story.update_attributes(story_params)      
      flash[:notice] = "Successfully updated story."
      params[:continue_editing] ? redirect_to(edit_story_path(@story)) : redirect_to(@story)
    else
      render :edit
    end
  end

  def destroy
    @story.destroy
    redirect_to stories_path, notice: "Successfully destroyed story."
  end
  
  private

  def story_params
    params.require(:story).permit(
      :category_id,
      :name,
      :description,
      :content,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: [],
      illustrations_attributes: [:id, :illustration, :_destroy]
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :story).order(:name)).resolve
  end

  def load_story
    @story = Story.find_by url: params[:id]
    authorize @story
  end

end
