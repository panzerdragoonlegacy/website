module LoadableForPage
  extend ActiveSupport::Concern

  private

  def load_page
    @page = Page.find_by url: params[:id]
    authorize @page
  end
end
