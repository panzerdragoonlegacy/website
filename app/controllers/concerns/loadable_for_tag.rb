module LoadableForTag
  extend ActiveSupport::Concern

  private

  def load_tag
    @tag = Tag.find_by slug: params[:id]
    authorize @tag
  end
end
