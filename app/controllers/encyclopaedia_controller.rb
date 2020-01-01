class EncyclopaediaController < ApplicationController
  include LoadableForEncyclopaedia
  include LoadableForPage

  def index
    load_category_groups
    @pages = policy_scope(
      Page.where(page_type: :encyclopaedia.to_s).order(:name)
        .page(params[:page])
    )
  end

  def show
    load_encyclopaedia_page
    load_news_entries
    load_literature
    load_downloads
    load_music_tracks
    load_pictures
    load_quizzes
    load_videos
  end
end
