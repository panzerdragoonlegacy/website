module LoadableForSaga
  extend ActiveSupport::Concern

  private

  def load_encyclopaedia_entries
    @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.order(:name))
  end

  def load_saga
    @saga = Saga.find_by url: params[:id]
    authorize @saga
  end
end
