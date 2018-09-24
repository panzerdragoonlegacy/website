module LoadableForCategory
  extend ActiveSupport::Concern

  private

  def load_category_groups
    @category_groups = CategoryGroupPolicy::Scope.new(
      current_user,
      CategoryGroup.order(:name)
    ).resolve
  end

  def load_sagas
    @sagas = SagaPolicy::Scope.new(
      current_user,
      Saga.order(:name)
    ).resolve
  end

  def load_category
    @category = Category.find_by url: params[:id]
    authorize @category
  end

  def load_category_articles
    if @category.category_type == 'article'
      @articles = ArticlePolicy::Scope.new(
        current_user,
        Article.where(category_id: @category.id).order(:name)
          .page(params[:page])
      ).resolve
    end
  end

  def load_category_downloads
    if @category.category_type == 'download'
      @downloads = DownloadPolicy::Scope.new(
        current_user,
        Download.where(
          category_id: @category.id
        ).order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_encyclopaedia_entries
    if @category.category_type == 'encyclopaedia_entry'
      @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
        current_user,
        EncyclopaediaEntry.where(category_id: @category.id)
          .order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_links
    if @category.category_type == 'link'
      @links = LinkPolicy::Scope.new(
        current_user,
        Link.where(category_id: @category.id).order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_music_tracks
    if @category.category_type == 'music_track'
      @music_tracks = MusicTrackPolicy::Scope.new(
        current_user,
        MusicTrack.where(category_id: @category.id).order(:track_number)
          .order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_pictures
    if @category.category_type == 'picture'
      @pictures = PicturePolicy::Scope.new(
        current_user,
        Picture.where(category_id: @category.id).order(:name)
          .page(params[:page])
      ).resolve
    end
  end

  def load_category_resources
    if @category.category_type == 'resource'
      @resources = ResourcePolicy::Scope.new(
        current_user,
        Resource.where(category_id: @category.id).order(:name)
          .page(params[:page])
      ).resolve
    end
  end

  def load_category_stories
    if @category.category_type == 'story'
      @stories = StoryPolicy::Scope.new(
        current_user,
        Story.where(category_id: @category.id).order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_videos
    if @category.category_type == 'video'
      @videos = VideoPolicy::Scope.new(
        current_user,
        Video.where(category_id: @category.id).order(:name).page(params[:page])
      ).resolve
    end
  end
end
