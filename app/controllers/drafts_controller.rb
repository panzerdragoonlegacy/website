class DraftsController < ApplicationController
  def index
    @articles = policy_scope(Article.where(publish: false).order(:name))
    @categories = policy_scope(Category.where(publish: false).order(:name))

    @chapter_count = policy_scope(Chapter.where(publish: false)).count
    @prologues = policy_scope(Chapter.where(publish: false, chapter_type: :prologue).order(:number))
    @regular_chapters = policy_scope(Chapter.where(publish: false, chapter_type: :regular_chapter).order(:number))
    @epilogues = policy_scope(Chapter.where(publish: false, chapter_type: :epilogue).order(:number))

    @downloads = policy_scope(Download.where(publish: false).order(:name))
    @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.where(publish: false).order(:name))
    @music_tracks = policy_scope(MusicTrack.where(publish: false).order(:name))
    @news_entries = policy_scope(NewsEntry.where(publish: false).order(:name))
    @pages = policy_scope(Page.where(publish: false).order(:name))
    @pictures = policy_scope(Picture.where(publish: false).order(:name))
    @poems = policy_scope(Poem.where(publish: false).order(:name))
    @quizzes = policy_scope(Quiz.where(publish: false).order(:name))
    @resources = policy_scope(Resource.where(publish: false).order(:name))
    @stories = policy_scope(Story.where(publish: false).order(:name))
    @videos = policy_scope(Video.where(publish: false).order(:name))
  end
end
