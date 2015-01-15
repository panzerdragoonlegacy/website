class DraftsController < ApplicationController
  def index
    @categories = policy_scope(Category.where(publish: false).order(:name).
      page(params[:page]))

    @news_entries = policy_scope(NewsEntry.where(publish: false).order(:name).
      page(params[:page]))

    @articles = policy_scope(Article.where(publish: false).order(:name).
      page(params[:page]))
    @downloads = policy_scope(Download.where(publish: false).order(:name).
      page(params[:page]))
    @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.where(
      publish: false).order(:name).page(params[:page]))
    @music_tracks = policy_scope(MusicTrack.where(publish: false).order(:name).
      page(params[:page]))
    @pictures = policy_scope(Picture.where(publish: false).order(:name).
      page(params[:page]))
    @poems = policy_scope(Poem.where(publish: false).order(:name).
      page(params[:page]))
    @quizzes = policy_scope(Quiz.where(publish: false).order(:name).
      page(params[:page]))
    @resources = policy_scope(Resource.where(publish: false).order(:name).
      page(params[:page]))
    @stories = policy_scope(Story.where(publish: false).order(:name).
      page(params[:page]))

    @chapter_count = policy_scope(Chapter.where(publish: false).
      page(params[:page])).count
    @prologues = policy_scope(Chapter.where(publish: false,
      chapter_type: :prologue).order(:number).page(params[:page]))
    @regular_chapters = policy_scope(Chapter.where(publish: false,
      chapter_type: :regular_chapter).order(:number).page(params[:page]))
    @epilogues = policy_scope(Chapter.where(publish: false,
      chapter_type: :epilogue).order(:number).page(params[:page]))

    @videos = policy_scope(Video.where(publish: false).order(:name).
      page(params[:page]))

    @pages = policy_scope(Page.where(publish: false).order(:name).
      page(params[:page]))
  end
end
