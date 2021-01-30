class TagsController < ApplicationController
  include LoadableForTag

  def show
    load_tag
    load_news_entries
    load_literature
    load_pictures
    load_music_tracks
    load_videos
    load_downloads
  end
end
