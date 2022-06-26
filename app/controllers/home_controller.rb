class HomeController < ApplicationController
  def show
    @featured_news_entry =
      policy_scope(
        NewsEntry
          .where(publish: true)
          .order('published_at desc')
      ).first
    @pictures =
      policy_scope(
        Picture
          .where(publish: true)
          .order('published_at desc')
          .limit(12)
      )
    @page =
      policy_scope(
        Page
          .where(page_type: :literature, publish: true)
          .order('published_at desc')
      ).first
    @music_track =
      policy_scope(
        MusicTrack
          .where(publish: true)
          .order('published_at desc')
      ).first
    @video =
      policy_scope(
        Video
          .where(publish: true)
          .order('published_at desc')
      ).first
    @download =
      policy_scope(
        Download
          .where(publish: true)
          .order('published_at desc')
      ).first
    if @featured_news_entry.present?
      @news_entries =
        policy_scope(
          NewsEntry
            .where(publish: true)
            .where.not(id: @featured_news_entry.id)
            .order(published_at: :desc)
            .page(params[:page])
        )
    end
  end
end
