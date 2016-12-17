module LoadableForChapter
  extend ActiveSupport::Concern

  private

  def load_chapter
    @chapter = Chapter.find_by url: params[:id]
    authorize @chapter.story
  end

  def load_previous_chapter
    all_chapters.each do |chapter|
      if chapter.number == (@chapter.number - 1) &&
         chapter.chapter_type == @chapter.chapter_type
        @previous_chapter = chapter
      end
    end
    load_previous_chapter_in_end_cases
  end

  def load_next_chapter
    all_chapters.each do |chapter|
      if chapter.number == (@chapter.number + 1) &&
         chapter.chapter_type == @chapter.chapter_type
        @next_chapter = chapter
      end
    end
    load_next_chapter_in_end_cases
  end

  def load_previous_chapter_in_end_cases
    if @chapter == regular_chapters.order(:number).first && prologues
      @previous_chapter = prologues.last
    elsif @chapter == epilogues.order(:number).first && regular_chapters
      @previous_chapter = regular_chapters.last
    end
  end

  def load_next_chapter_in_end_cases
    if @chapter == prologues.order(:number).last && regular_chapters
      @next_chapter = regular_chapters.first
    elsif @chapter == regular_chapters.order(:number).last && epilogues
      @next_chapter = epilogues.first
    end
  end

  def all_chapters
    @chapter.story.chapters
  end

  def prologues
    @chapter.story.chapters.where(chapter_type: :prologue).order(:number)
  end

  def regular_chapters
    @chapter.story.chapters.where(
      chapter_type: :regular_chapter
    ).order(:number)
  end

  def epilogues
    @chapter.story.chapters.where(chapter_type: :epilogue).order(:number)
  end
end
