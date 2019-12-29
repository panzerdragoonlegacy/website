class EncyclopaediaEntriesController < ApplicationController
  include LoadableForEncyclopaediaEntry

  def index
    load_category_groups
    @encyclopaedia_entries = policy_scope(
      EncyclopaediaEntry.order(:name).page(params[:page])
    )
  end

  def show
    load_encyclopaedia_entry
    load_news_entries
    load_literature
    load_downloads
    load_music_tracks
    load_pictures
    load_quizzes
    load_videos
  end
end
