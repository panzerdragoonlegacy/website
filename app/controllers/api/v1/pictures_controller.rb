class Api::V1::PicturesController < ApplicationController
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
            .where(sequence_number: 1)
            .order(:name)
            .page(params[:page])
            .per(PICTURES_PER_PAGE)
        )
    end
    render template: 'api/v1/pictures/index', formats: :json
  end

  def show
    load_picture
    @tags =
      TagPolicy::Scope.new(
        current_user,
        Tag.where(name: @picture.tags.map { |tag| tag.name }).order(:name)
      ).resolve
    render template: 'api/v1/pictures/show', formats: :json
  end
end
