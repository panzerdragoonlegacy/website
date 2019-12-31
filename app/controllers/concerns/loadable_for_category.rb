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

  def load_category_encyclopaedia_entries
    if @category.category_type == 'encyclopaedia_entry'
      @encyclopaedia_entries = PagePolicy::Scope.new(
        current_user,
        Page.where(category_id: @category.id, page_type: :encyclopaedia.to_s)
          .order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_literature
    if @category.category_type == 'literature'
      @works_of_literature = PagePolicy::Scope.new(
        current_user,
        Page.where(category_id: @category.id, page_type: :literature.to_s)
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

  def load_category_music_tracks
    if @category.category_type == 'music_track'
      @music_tracks = MusicTrackPolicy::Scope.new(
        current_user,
        MusicTrack.where(category_id: @category.id).order(:track_number)
          .order(:name).page(params[:page])
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
end
