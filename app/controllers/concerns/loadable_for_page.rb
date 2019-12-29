module LoadableForPage
  extend ActiveSupport::Concern

  private

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user, Category.where(category_type: :literature).order(:name)
    ).resolve
  end

  def load_parent_pages
    @parent_pages = PagePolicy::Scope.new(
      current_user, Page.where(page_type: :literature.to_s).order(:name)
    ).resolve
  end

  def load_page
    @page = Page.find_by id: params[:id]
    authorize @page
  end

  def load_draft_pages
    @pages = policy_scope(
      Page.where(publish: false).order(:name).page(params[:page])
    )
  end
end
