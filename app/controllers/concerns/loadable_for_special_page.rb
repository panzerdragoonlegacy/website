module LoadableForSpecialPage
  extend ActiveSupport::Concern

  private

  def load_special_page
    @special_page = SpecialPage.find_by url: params[:id]
    authorize @special_page
  end
end
