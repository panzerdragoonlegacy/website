class SpecialPagesController < ApplicationController
  include LoadableForSpecialPage

  def show
    load_special_page
  end
end
