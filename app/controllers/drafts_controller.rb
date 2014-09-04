class DraftsController < ApplicationController
  def index
    @articles = policy_scope(Article.where(publish: false).order(:name))
    @categories = policy_scope(Category.where(publish: false).order(:name))
    @chapters = policy_scope(Chapter.where(publish: false).order(:name))
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
