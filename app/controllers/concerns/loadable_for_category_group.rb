module LoadableForCategoryGroup
  extend ActiveSupport::Concern

  private
  
  def load_category_group
    @category_group = CategoryGroup.find_by slug: params[:id]
    authorize @category_group
  end
end
