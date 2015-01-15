class CategoriesController < ApplicationController
  before_action :load_category, except: [:index, :new, :create]

  def index
    @article_categories = policy_scope(Category.where(
      category_type: :article).order(:name))
    @download_categories = policy_scope(Category.where(
      category_type: :download).order(:name))
    @encyclopaedia_entry_categories = policy_scope(Category.where(
      category_type: :encyclopaedia_entry).order(:name))
    @link_categories = policy_scope(Category.where(
      category_type: :link).order(:name))
    @music_track_categories = policy_scope(Category.where(
      category_type: :music_track).order(:name))
    @picture_categories = policy_scope(Category.where(
      category_type: :picture).order(:name))
    @resource_categories = policy_scope(Category.where(
      category_type: :resource).order(:name))
    @story_categories = policy_scope(Category.where(
      category_type: :story).order(:name))
    @video_categories = policy_scope(Category.where(
      category_type: :video).order(:name))
  end

  def show
    # This could potentially be replaced with @category.articles,
    # @category.downloads, etc
    case @category.category_type
    when "article"
      @articles = ArticlePolicy::Scope.new(current_user, Article.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    when "download"
      @downloads = DownloadPolicy::Scope.new(current_user, Download.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    when "encyclopaedia_entry"
      @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
        current_user, EncyclopaediaEntry.where(category_id: @category.id
        ).order(:name).page(params[:page])).resolve
    when "link"
      @links = LinkPolicy::Scope.new(current_user, Link.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    when "music_track"
      @music_tracks = MusicTrackPolicy::Scope.new(current_user,
        MusicTrack.where(category_id: @category.id).order(
        :track_number).order(:name).page(params[:page])).resolve
    when "picture"
      @pictures = PicturePolicy::Scope.new(current_user, Picture.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    when "resource"
      @resources = ResourcePolicy::Scope.new(current_user, Resource.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    when "story"
      @stories = StoryPolicy::Scope.new(current_user, Story.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    when "video"
      @videos = VideoPolicy::Scope.new(current_user, Video.where(
        category_id: @category.id).order(:name).page(params[:page])).resolve
    end
  end

  def new
    @category = Category.new
    authorize @category
  end

  def create
    @category = Category.new(category_params)
    authorize @category
    if @category.save
      flash[:notice] = "Successfully created category."
      if params[:continue_editing]
        redirect_to edit_category_path(@category)
      else
        redirect_to @category
      end
    else
      render :new
    end
  end

  def update
    if @category.update_attributes(category_params)
      flash[:notice] = "Successfully updated category."
      if params[:continue_editing]
        redirect_to edit_category_path(@category)
      else
        redirect_to @category
      end
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path, notice: "Successfully destroyed category."
  end

  private

  def category_params
    params.require(:category).permit(
      :name,
      :description,
      :category_type,
      :publish
    )
  end

  def load_category
    @category = Category.find_by url: params[:id]
    authorize @category
  end
end
