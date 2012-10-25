class ChaptersController < ApplicationController
  load_resource :find_by => :url
  authorize_resource
  
  def show
    previous_and_next_chapters
    @commentable = @chapter
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.all
  end

  def new
    if params[:story]
      @chapter.story_id = Story.find_by_url(params[:story]).id
    end
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    if @chapter.save
      redirect_to @chapter, :notice => "Successfully created chapter."
    else
      render 'new'
    end
  end
  
  def update
    if @chapter.update_attributes(params[:chapter])
      redirect_to @chapter, :notice => "Successfully updated chapter."
    else
      render 'edit'
    end
  end

  def destroy    
    story = @chapter.story
    @chapter.destroy
    redirect_to story_path(story), :notice => "Successfully destroyed chapter."
  end
  
private

  def previous_and_next_chapters
    all_chapters =  @chapter.story.chapters.accessible_by(current_ability)
    prologues = @chapter.story.chapters.accessible_by(current_ability).where(:chapter_type => :prologue).order(:number)
    regular_chapters = @chapter.story.chapters.accessible_by(current_ability).where(:chapter_type => :regular_chapter).order(:number)
    epilogues = @chapter.story.chapters.accessible_by(current_ability).where(:chapter_type => :epilogue).order(:number)
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