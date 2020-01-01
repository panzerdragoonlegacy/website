class ChaptersController < ApplicationController
  include LoadableForPage

  def show
    load_chapter
    load_tags
  end

  private

  def load_chapter
    @page =
      Page.where(id: params[:id], parent_page_id: params[:literature_id]).first
    authorize @page
  end
end
