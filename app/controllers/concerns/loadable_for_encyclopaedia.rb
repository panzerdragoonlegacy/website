module LoadableForEncyclopaedia
  extend ActiveSupport::Concern

  private

  def load_encyclopaedia_page
    @page = Page.where(id: params[:id], page_type: :encyclopaedia.to_s).first
    authorize @page
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(
        category_group_type: :encyclopaedia
      ).order(:name)
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :encyclopaedia).order(:name)
    ).resolve
  end

  def load_news_entries
    @news_entries = NewsEntryPolicy::Scope.new(
      current_user,
      NewsEntry.includes(:tags).where(tags: { name: @page.name })
        .limit(50).order(published_at: :desc)
    ).resolve
  end

  def load_literature
    @works_of_literature = PagePolicy::Scope.new(
      current_user,
      Page.includes(:tags).where(
        page_type: :literature.to_s,
        tags: { name: @page.name }
      ).limit(50).order(:name)
    ).resolve
  end

  def load_downloads
    @downloads = DownloadPolicy::Scope.new(
      current_user,
      Download.includes(:tags).where(tags: { name: @page.name })
        .limit(50).order(:name)
    ).resolve
  end

  def load_music_tracks
    @music_tracks = MusicTrackPolicy::Scope.new(
      current_user,
      MusicTrack.includes(:tags)
        .where(tags: { name: @page.name })
          .limit(50).order(:name)
    ).resolve
  end

  def load_pictures
    @pictures = PicturePolicy::Scope.new(
      current_user,
      Picture.includes(:tags).where(tags: { name: @page.name })
        .limit(50).order(published_at: :desc)
    ).resolve
  end

  def load_quizzes
    @quizzes = QuizPolicy::Scope.new(
      current_user,
      Quiz.includes(:tags).where(tags: { name: @page.name })
        .limit(50).order(:name)
    ).resolve
  end

  def load_videos
    @videos = VideoPolicy::Scope.new(
      current_user,
      Video.includes(:tags).where(tags: { name: @page.name })
        .limit(50).order(:name)
    ).resolve
  end
end
