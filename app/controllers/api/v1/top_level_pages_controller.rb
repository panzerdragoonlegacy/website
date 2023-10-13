class Api::V1::TopLevelPagesController < ApplicationController
  include PreviewSlugConcerns

  def show
    load_page
    render template: 'api/v1/top_level_pages/show', formats: :json
  end

  private

  def load_page
    @page = Page.find_by slug: previewless_slug(params[:id])
    authorize @page
  end
end
