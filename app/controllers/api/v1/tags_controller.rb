class Api::V1::TagsController < ApplicationController
  include LoadableForTag

  def show
    load_tag
    render template: 'api/v1/tags/show', formats: :json
  end
end
