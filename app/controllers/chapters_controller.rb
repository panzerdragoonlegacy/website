class ChaptersController < ApplicationController
  include LoadableForChapter

  def show
    load_chapter
    load_previous_chapter
    load_next_chapter
  end
end
