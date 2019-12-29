class CategoriesController < ApplicationController
  include LoadableForCategory

  def index
    redirect_to site_map_path
  end

  def show
    load_category
    load_category_literature
    load_category_articles
    load_category_downloads
    load_category_encyclopaedia_entries
    load_category_links
    load_category_music_tracks
    load_category_pictures
    load_category_resources
    load_category_stories
    load_category_videos
  end
end
