class CategoriesController < ApplicationController
  before_action :load_category_groups, except: [:index, :show, :destroy]
  before_action :load_category, except: [:index, :new, :create]

  def index
    if params[:filter] == 'draft'
      @categories = policy_scope(Category.where(publish: false).order(:name)
        .page(params[:page]))
    else
      redirect_to site_map_path
    end
  end

  def show
    case @category.category_type
    when 'article'
      load_category_articles
    when 'download'
      load_category_downloads
    when 'encyclopaedia_entry'
      load_category_encyclopaedia_entries
    when 'link'
      load_category_links
    when 'music_track'
      load_category_music_tracks
    when 'picture'
      load_category_pictures
    when 'resource'
      load_category_resources
    when 'story'
      load_category_stories
    when 'video'
      load_category_videos
    end
  end

  def new
    @category = Category.new(category_type: params[:category_type])
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category
    if @category.save
      flash[:notice] = 'Successfully created category.'
      redirect_to_category
    else
      render :new
    end
  end

  def update
    if @category.update_attributes(category_params)
      flash[:notice] = 'Successfully updated category.'
      redirect_to_category
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to site_map_path, notice: 'Successfully destroyed category.'
  end

  private

  def category_params
    params.require(:category).permit(
      :category_type,
      :category_group_id,
      :name,
      :description,
      :publish
    )
  end

  def load_category_groups
    @category_groups = CategoryGroupPolicy::Scope.new(
      current_user,
      CategoryGroup.order(:name)
    ).resolve
  end

  def load_category
    @category = Category.find_by url: params[:id]
    authorize @category
  end

  def load_category_articles
    @articles = ArticlePolicy::Scope.new(current_user, Article.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def load_category_downloads
    @downloads = DownloadPolicy::Scope.new(current_user, Download.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def load_category_encyclopaedia_entries
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      EncyclopaediaEntry.where(category_id: @category.id).order(:name)
        .page(params[:page])
    ).resolve
  end

  def load_category_links
    @links = LinkPolicy::Scope.new(current_user, Link.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def load_category_music_tracks
    @music_tracks = MusicTrackPolicy::Scope.new(
      current_user,
      MusicTrack.where(category_id: @category.id).order(:track_number)
        .order(:name).page(params[:page])
    ).resolve
  end

  def load_category_pictures
    @pictures = PicturePolicy::Scope.new(current_user, Picture.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def load_category_resources
    @resources = ResourcePolicy::Scope.new(current_user, Resource.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def load_category_stories
    @stories = StoryPolicy::Scope.new(current_user, Story.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def load_category_videos
    @videos = VideoPolicy::Scope.new(current_user, Video.where(
      category_id: @category.id).order(:name).page(params[:page])).resolve
  end

  def redirect_to_category
    if params[:continue_editing]
      redirect_to edit_category_path(@category)
    else
      redirect_to @category
    end
  end
end
