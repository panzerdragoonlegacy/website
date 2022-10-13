class CategoriesController < ApplicationController
  include LoadableForCategory

  def show
    load_category
    load_category_literature_pages
    load_category_pictures
    load_category_music_tracks
    load_category_videos
    load_category_downloads
  end
end
