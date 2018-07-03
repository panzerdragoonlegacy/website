class Admin::ChaptersController < ApplicationController
  include LoadableForChapter
  layout 'admin'
  before_action :load_chapter, except: [:new, :create]

  def new
    story = Story.find_by url: params[:story]
    raise 'Story not found.' unless story.present?
    @chapter = Chapter.new story_id: story.id
    authorize @chapter.story
  end

  def create
    @chapter = Chapter.new chapter_params
    authorize @chapter.story
    if @chapter.save
      flash[:notice] = 'Successfully created chapter.'
      redirect_to_chapter
    else
      render :new
    end
  end

  def update
    if @chapter.update_attributes chapter_params
      flash[:notice] = 'Successfully updated chapter.'
      redirect_to_chapter
    else
      render :edit
    end
  end

  def destroy
    @chapter.destroy
    redirect_to admin_stories_path, notice: 'Successfully destroyed chapter.'
  end

  private

  def chapter_params
    params.require(:chapter).permit(
      :story_id,
      :chapter_type,
      :number,
      :name,
      :content,
      illustrations_attributes: [:id, :illustration, :_destroy]
    )
  end

  def redirect_to_chapter
    if params[:continue_editing]
      redirect_to edit_admin_chapter_path(@chapter)
    else
      redirect_to @chapter
    end
  end
end
