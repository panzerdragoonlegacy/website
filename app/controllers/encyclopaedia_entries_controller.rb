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
    load_articles
    load_downloads
    load_links
    load_music_tracks
    load_pictures
    load_poems
    load_quizzes
    load_resources
    load_stories
    load_videos
  end
end
