class SagasController < ApplicationController
  include LoadableForSaga

  def show
    load_saga
    load_categories
  end

  def load_categories
    @categories = {}
    MediaType::all.each do |key, value|
      @categories[key] = policy_scope(
        @saga.categories.where(category_type: key.to_s).order(:name)
      )
    end
  end
end
