class Redesign::TagsController < ApplicationController
  layout 'redesign'
  include LoadableForTag

  def show
    load_tag
  end
end
