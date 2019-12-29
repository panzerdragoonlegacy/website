class LiteratureController < ApplicationController
  include LoadableForLiterature

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
    load_page
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @page.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
