class Redesign::CategoriesController < ApplicationController
  layout 'redesign'
  include PreviewSlugConcerns

  def show
    @category =
      Category
        .where(slug: previewless_slug(params[:id]))
        .includes(:categorisations)
        .first
    authorize @category
  end
end
