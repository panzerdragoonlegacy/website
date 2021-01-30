class TopLevelPageController < ApplicationController
  include LoadableForSaga

  def show
    if Saga.where(url: params[:id]).count > 0
      load_saga
      load_tag_for_saga
      load_categories
    else
      load_page
    end
  end

  private

  def load_categories
    @categories = {}
    MediaType::all.each do |key, value|
      @categories[key] = policy_scope(
        @saga.categories.where(category_type: key.to_s).order(:name)
      )
    end
  end

  def load_page
    @page = Page.find_by url: params[:id]
    authorize @page
  end
end
