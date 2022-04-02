class Redesign::HomeController < ApplicationController
  layout 'redesign'

  def show
    @featured_news_entry =
      policy_scope(NewsEntry.order('published_at desc')).first
    @pictures = policy_scope(Picture.order('published_at desc').limit(4))
    @page = policy_scope(
      Page.where(page_type: :literature).order('published_at desc')
    ).first
    @music_track = policy_scope(MusicTrack.order('published_at desc')).first
    @video = policy_scope(Video.order('published_at desc')).first
    @download = policy_scope(Download.order('published_at desc')).first
    if @featured_news_entry.present?
      @news_entries =
        policy_scope(
          NewsEntry
            .where.not(id: @featured_news_entry.id)
            .order(published_at: :desc)
            .page(params[:page])
        )
    end
  end
end
