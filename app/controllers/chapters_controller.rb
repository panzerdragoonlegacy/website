class ChaptersController < ApplicationController
  
  before_action :load_chapter, except: [:index, :new, :create]

  def show
    previous_and_next_chapters
  end

  def new
    story = Story.find_by url: params[:story]
    raise "Story not found." unless story.present?
    @chapter = Chapter.new(story_id: story.id)
    authorize @chapter
  end

  def create
    @chapter = Chapter.new(chapter_params)
    authorize @chapter
    if @chapter.save
      redirect_to @chapter, notice: "Successfully created chapter."
    else
      render :new
    end
  end

  def update
    if @chapter.update_attributes(chapter_params)
      redirect_to @chapter, notice: "Successfully updated chapter."
    else
      render :edit
    end
  end

  def destroy
    story = @chapter.story
    @chapter.destroy
    redirect_to story_path(story), notice: "Successfully destroyed chapter."
  end
  
  private

  def chapter_params
    params.require(:chapter).permit(
      :story_id,
      :chapter_type,
      :number,
      :name,
      :content,
      :publish,
      illustrations_attributes: [:id, :illustration, :_destroy]
    )
  end

  def load_chapter
    @chapter = Chapter.find_by url: params[:id]
    authorize @chapter
  end

  def previous_and_next_chapters
    all_chapters =  policy_scope(@chapter.story.chapters)
    prologues = policy_scope(@chapter.story.chapters.where(chapter_type: :prologue).order(:number))
    regular_chapters = policy_scope(@chapter.story.chapters.where(chapter_type: :regular_chapter).order(:number))
    epilogues = policy_scope(@chapter.story.chapters.where(chapter_type: :epilogue).order(:number))

    all_chapters.each do |chapter|
      if (chapter.number == @chapter.number - 1) && (chapter.chapter_type == @chapter.chapter_type)
        @previous_chapter = chapter
      end
  	  if (chapter.number == @chapter.number + 1) && (chapter.chapter_type == @chapter.chapter_type)
  	    @next_chapter = chapter
  	  end
  	end
  	if (@chapter == prologues.order(:number).last) && regular_chapters
  	  @next_chapter = regular_chapters.first
  	end
	  if (@chapter == regular_chapters.order(:number).first) && prologues
      @previous_chapter = prologues.last
    end
    if (@chapter == regular_chapters.order(:number).last) && epilogues
      @next_chapter = epilogues.first
    end
    if (@chapter == epilogues.order(:number).first) && regular_chapters
      @previous_chapter = regular_chapters.last
    end
  end
  
end
