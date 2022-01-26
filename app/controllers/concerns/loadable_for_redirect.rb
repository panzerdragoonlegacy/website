module LoadableForRedirect
  extend ActiveSupport::Concern

  private

  def load_redirect
    @redirect = Redirect.find params[:id]
    authorize @redirect
  end
end
