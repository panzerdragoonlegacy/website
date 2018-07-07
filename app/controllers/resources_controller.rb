class ResourcesController < ApplicationController
  include LoadableForResource

  def index
    if params[:contributor_profile_id]
      load_contributors_resources
    else
      load_category_groups
      @resources = policy_scope(Resource.order(:name).page(params[:page]))
    end
  end

  def show
    load_resource
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @resource.encyclopaedia_entries.order(:name)
    ).resolve
  end
end
