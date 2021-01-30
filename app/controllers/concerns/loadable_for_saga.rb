module LoadableForSaga
  extend ActiveSupport::Concern

  private

  def load_saga
    @saga = Saga.find_by url: params[:id]
    authorize @saga
  end

  def load_tag_for_saga
    @tag = Tag.find_by url: params[:id]
    authorize @tag if @tag
  end

  def load_pages
    @pages = policy_scope(Page.where(page_type: :encyclopaedia).order(:name))
  end
end
