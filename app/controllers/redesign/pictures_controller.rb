class Redesign::PicturesController < ApplicationController
  layout 'redesign'
  include LoadableForPicture

  def index
    if params[:contributor_profile_id]
      load_contributors_pictures
    elsif params[:tag_id]
      load_tagged_pictures
    else
      @pictures =
        policy_scope(
          Picture
            .where(sequence_number: [0, 1])
            .order(:name)
            .page(params[:page])
        )
    end
  end

  def show
    load_picture
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @picture.tags.map { |tag| tag.name }).order(:name)
      ).resolve
  end
end
