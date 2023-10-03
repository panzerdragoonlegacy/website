class Api::V1::LiteratureController < ApplicationController
  include LoadableForLiterature
  include LoadableForPage

  def index
    if params[:contributor_profile_id]
      load_contributors_literature
    elsif params[:tag_id]
      load_tagged_literature
    else
      @pages =
        policy_scope(
          Page.where(page_type: :literature).order(:name).page(params[:page])
        )
    end
    render template: 'api/v1/literature/index', formats: :json
  end

  def show
    load_literature_page
    load_tags
    render template: 'api/v1/literature/show', formats: :json
  end
end
