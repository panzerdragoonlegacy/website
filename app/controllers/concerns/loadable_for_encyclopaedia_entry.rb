module LoadableForEncyclopaediaEntry
  extend ActiveSupport::Concern

  private

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(
        category_group_type: :encyclopaedia_entry
      ).order(:name)
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :encyclopaedia_entry).order(:name)
    ).resolve
  end

  def load_encyclopaedia_entry
    @encyclopaedia_entry = EncyclopaediaEntry.find_by url: params[:id]
    authorize @encyclopaedia_entry
  end

  def load_draft_encyclopaedia_entries
    @encyclopaedia_entries = policy_scope(
      EncyclopaediaEntry.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_news_entries
    @news_entries = NewsEntryPolicy::Scope.new(
      current_user,
      NewsEntry.includes(:tags).where(tags: { name: @encyclopaedia_entry.name })
        .limit(50).order(published_at: :desc)
    ).resolve
  end

  def load_literature
    @pages = PagePolicy::Scope.new(
      current_user,
      Page.includes(:tags).where(
        page_type: :literature.to_s,
        tags: { name: @encyclopaedia_entry.name }
      ).limit(50).order(:name)
    ).resolve
  end

  def load_downloads
    @downloads = DownloadPolicy::Scope.new(
      current_user,
      Download.includes(:tags).where(tags: { name: @encyclopaedia_entry.name })
        .limit(50).order(:name)
    ).resolve
  end

  def load_music_tracks
    @music_tracks = MusicTrackPolicy::Scope.new(
      current_user,
      MusicTrack.includes(:tags)
        .where(tags: { name: @encyclopaedia_entry.name })
          .limit(50).order(:name)
    ).resolve
  end

  def load_pictures
    @pictures = PicturePolicy::Scope.new(
      current_user,
      Picture.includes(:tags).where(tags: { name: @encyclopaedia_entry.name })
        .limit(50).order(published_at: :desc)
    ).resolve
  end

  def load_quizzes
    @quizzes = QuizPolicy::Scope.new(
      current_user,
      Quiz.includes(:tags).where(tags: { name: @encyclopaedia_entry.name })
        .limit(50).order(:name)
    ).resolve
  end

  def load_videos
    @videos = VideoPolicy::Scope.new(
      current_user,
      Video.includes(:tags).where(tags: { name: @encyclopaedia_entry.name })
        .limit(50).order(:name)
    ).resolve
  end
end
