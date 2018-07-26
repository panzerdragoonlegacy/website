class StoriesController < ApplicationController
  include LoadableForStory

  def index
    load_categories
    if params[:contributor_profile_id]
      load_contributors_stories
    else
      @stories = policy_scope(Story.order(:name).page(params[:page]))
    end
  end

  def show
    load_story
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(name: @story.tags.map { |tag| tag.name })
        .order(:name)
    ).resolve
  end
end
