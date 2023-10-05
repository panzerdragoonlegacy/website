class Api::V1::ChaptersController < ApplicationController
  include LoadableForPage

  def show
    load_literature_chapter_page
    load_tags
    render template: 'api/v1/chapters/show', formats: :json
  end

  private

  def load_literature_chapter_page
    @page =
      Page.where(
        id: params[:id],
        parent_page_id: params[:literature_id],
        page_type: :literature_chapter
      ).first
    authorize @page
  end
end
