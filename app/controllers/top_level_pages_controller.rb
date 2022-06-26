class TopLevelPagesController < ApplicationController
  include PreviewSlugConcerns

  def show
    load_page
  end

  private

  def load_page
    @page = Page.find_by slug: previewless_slug(params[:id])
    authorize @page
  end
end
