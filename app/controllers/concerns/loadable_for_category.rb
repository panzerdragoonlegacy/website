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

  def load_category_encyclopaedia_pages
    if @category.category_type == :encyclopaedia.to_s
      @encyclopaedia_pages = PagePolicy::Scope.new(
        current_user,
        Page.where(category_id: @category.id, page_type: :encyclopaedia.to_s)
          .order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_literature_pages
    if @category.category_type == :literature.to_s
      @literature_pages = PagePolicy::Scope.new(
        current_user,
        Page.where(category_id: @category.id, page_type: :literature.to_s)
          .order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_pictures
    if @category.category_type == :picture.to_s
      @pictures = PicturePolicy::Scope.new(
        current_user,
        Picture.where(category_id: @category.id, sequence_number: [0, 1])
          .order(:name).page(params[:page])
      ).resolve
      @group_pictures_into_albums = true
    end
  end

  def load_category_music_tracks
    if @category.category_type == :music_track.to_s
      @music_tracks = MusicTrackPolicy::Scope.new(
        current_user,
        MusicTrack.where(category_id: @category.id).order(:track_number)
          .order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_videos
    if @category.category_type == :video.to_s
      @videos = VideoPolicy::Scope.new(
        current_user,
        Video.where(category_id: @category.id).order(:name).page(params[:page])
      ).resolve
    end
  end

  def load_category_downloads
    if @category.category_type == :download.to_s
      @downloads = DownloadPolicy::Scope.new(
        current_user,
        Download.where(
          category_id: @category.id
        ).order(:name).page(params[:page])
      ).resolve
    end
  end
end
