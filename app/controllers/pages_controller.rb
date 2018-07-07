class PagesController < ApplicationController
  include LoadableForPage

  def show
    load_page
  end
end
