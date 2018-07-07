class LinksController < ApplicationController
  include LoadableForLink

  def index
    load_categories
    if params[:contributor_profile_id]
      load_contributors_links
    else
      @links = policy_scope(Link.order(:name).page(params[:page]))
    end
  end

  def show
    load_link
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @link.encyclopaedia_entries.order(:name)
    ).resolve
  end
end
