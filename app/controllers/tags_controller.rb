class TagsController < ApplicationController
  include LoadableForTag

  def show
    load_tag
    load_encyclopadia_entry
    load_news_entries
    load_literature
    load_pictures
    load_music_tracks
    load_videos
    load_downloads
  end

  private

  def load_encyclopadia_entry
    @encyclopaedia_entry = Page.where(
      page_type: :encyclopaedia.to_s, url: @tag.url
    ).first
  end
end
