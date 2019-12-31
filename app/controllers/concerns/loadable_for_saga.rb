module LoadableForSaga
  extend ActiveSupport::Concern

  private

  def load_pages
    @pages = policy_scope(Page.where(page_type: :encyclopaedia).order(:name))
  end

  def load_saga
    @saga = Saga.find_by url: params[:id]
    authorize @saga
  end
end
