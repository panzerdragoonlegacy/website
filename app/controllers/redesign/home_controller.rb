class Redesign::HomeController < ApplicationController
  layout 'redesign'

  def show
    @featured_news_entry = NewsEntry.order('published_at desc').first
    authorize @featured_news_entry
    @pictures = policy_scope(Picture.order('published_at desc').limit(4))
    @page = Page.where(page_type: :literature).order('published_at desc').first
    authorize @page
    @music_track = MusicTrack.order('published_at desc').first
    authorize @music_track
    @video = Video.order('published_at desc').first
    authorize @video
    @download = Download.order('published_at desc').first
    authorize @download
    @news_entries =
      policy_scope(
        NewsEntry
          .where.not(id: @featured_news_entry.id)
          .order(published_at: :desc)
          .page(params[:page])
      )
  end
end
