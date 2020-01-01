class LiteratureController < ApplicationController
  include LoadableForLiterature
  include LoadableForPage

  def index
    if params[:contributor_profile_id]
      load_contributors_literature
    else
      load_category_groups
      @pages = policy_scope(
        Page.where(page_type: :literature).order(:name).page(params[:page])
      )
    end
  end

  def show
    load_literature_page
    load_tags
  end
end
