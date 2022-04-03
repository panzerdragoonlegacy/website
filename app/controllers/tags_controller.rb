class TagsController < ApplicationController
  include LoadableForTag

  def show
    load_tag
  end
end
