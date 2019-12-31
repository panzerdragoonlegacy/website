class ChaptersController < ApplicationController
  def show
    load_chapter
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @page.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end

  private

  def load_chapter
    @page =
      Page.where(id: params[:id], parent_page_id: params[:literature_id]).first
    authorize @page
  end
end
