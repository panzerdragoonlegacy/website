module LoadableForTag
  extend ActiveSupport::Concern

  private

  def load_tag
    @tag = Tag.find_by url: params[:id]
    authorize @tag
  end

  def load_articles
    @articles = ArticlePolicy::Scope.new(
      current_user,
      Article.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_downloads
    @downloads = DownloadPolicy::Scope.new(
      current_user,
      Download.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_links
    @links = LinkPolicy::Scope.new(
      current_user,
      Link.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_music_tracks
    @music_tracks = MusicTrackPolicy::Scope.new(
      current_user,
      MusicTrack.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_pictures
    @pictures = PicturePolicy::Scope.new(
      current_user,
      Picture.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_poems
    @poems = PoemPolicy::Scope.new(
      current_user,
      Poem.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_quizzes
    @quizzes = QuizPolicy::Scope.new(
      current_user,
      Quiz.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_resources
    @resources = ResourcePolicy::Scope.new(
      current_user,
      Resource.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_stories
    @stories = StoryPolicy::Scope.new(
      current_user,
      Story.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end

  def load_videos
    @videos = VideoPolicy::Scope.new(
      current_user,
      Video.includes(:tags).where(tags: { name: @tag.name }).order(:name)
    ).resolve
  end
end
