class PicturesController < ApplicationController
  include LoadableForPicture

  def index
    if params[:contributor_profile_id]
      load_contributors_pictures
    else
      load_category_groups
      @pictures = policy_scope(Picture.order(:name).page(params[:page]))
    end
  end

  def show
    load_picture
    load_picture_to_replace
    load_other_pictures_in_album
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @picture.encyclopaedia_entries.order(:name)
    ).resolve
  end
end
