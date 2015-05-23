class SiteMapController < ApplicationController
  after_action :verify_authorized, except: [:show]

  def show
    @category_groups = policy_scope(CategoryGroup.order(:name))
    @categories = policy_scope(Category.order(:name))
  end
end
