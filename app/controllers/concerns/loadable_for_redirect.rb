module LoadableForRedirect
  extend ActiveSupport::Concern

  private

  def load_redirect
    @redirect = Redirect.find_by id: params[:id]
    authorize @redirect
  end
end
