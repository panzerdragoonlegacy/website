class TagsController < ApplicationController
  include LoadableForTag

  def show
    load_tag
    load_encyclopadia_entry
    load_news_entries
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

  private

  def load_encyclopadia_entry
    @encyclopaedia_entry = EncyclopaediaEntry.where(url: @tag.url).first
  end
end
