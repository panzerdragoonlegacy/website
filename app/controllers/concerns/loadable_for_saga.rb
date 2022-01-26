module LoadableForSaga
  extend ActiveSupport::Concern

  private

  def load_saga
    @saga = Saga.find_by slug: params[:id]
    authorize @saga
  end

  def load_tags
    @tags = policy_scope(Tag.order(:name))
  end
end
