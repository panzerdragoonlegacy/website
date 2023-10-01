class Api::V1::CategoriesController < ApplicationController
  include LoadableForCategory

  def show
    load_category
    load_category_literature_pages
    load_category_pictures
    load_category_music_tracks
    load_category_videos
    load_category_downloads
    render template: 'api/v1/categories/show', formats: :json
  end
end
