class EncyclopaediaEntriesController < ApplicationController
  before_action :load_categories, except: [:index, :show, :destroy]
  before_action :load_encyclopaedia_entry, except: [:index, :new, :create]

  def index
    if params[:filter] == 'draft'
      load_draft_encyclopaedia_entries
    else
      @category_groups = policy_scope(CategoryGroup.where(
        category_group_type: :encyclopaedia_entry).order(:name))
      @encyclopaedia_entries = policy_scope(EncyclopaediaEntry.order(
        :name).page(params[:page]))
    end
  end

  def show
    @articles = ArticlePolicy::Scope.new(current_user,
      @encyclopaedia_entry.articles.order(:name)).resolve
    @downloads = DownloadPolicy::Scope.new(current_user,
      @encyclopaedia_entry.downloads.order(:name)).resolve
    @links = LinkPolicy::Scope.new(current_user,
      @encyclopaedia_entry.links.order(:name)).resolve
    @music_tracks = MusicTrackPolicy::Scope.new(current_user,
      @encyclopaedia_entry.music_tracks.order(:name)).resolve
    @pictures = PicturePolicy::Scope.new(current_user,
      @encyclopaedia_entry.pictures.order(:name)).resolve
    @poems = PoemPolicy::Scope.new(current_user,
      @encyclopaedia_entry.poems.order(:name)).resolve
    @quizzes = QuizPolicy::Scope.new(current_user,
      @encyclopaedia_entry.quizzes.order(:name)).resolve
    @resources = ResourcePolicy::Scope.new(current_user,
      @encyclopaedia_entry.resources.order(:name)).resolve
    @stories = StoryPolicy::Scope.new(current_user,
      @encyclopaedia_entry.stories.order(:name)).resolve
    @videos = VideoPolicy::Scope.new(current_user,
      @encyclopaedia_entry.videos.order(:name)).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @encyclopaedia_entry = EncyclopaediaEntry.new category: category
    else
      @encyclopaedia_entry = EncyclopaediaEntry.new
    end
    authorize @encyclopaedia_entry
  end

  def create
    @encyclopaedia_entry = EncyclopaediaEntry.new(encyclopaedia_entry_params)
    authorize @encyclopaedia_entry
    if @encyclopaedia_entry.save
      flash[:notice] = 'Successfully created encyclopaedia entry.'
      redirect_to_encyclopaedia_entry
    else
      render :new
    end
  end

  def update
    params[:encyclopaedia_entry][:contributor_profile_ids] ||= []
    params[:encyclopaedia_entry][:article_ids] ||= []
    params[:encyclopaedia_entry][:download_ids] ||= []
    params[:encyclopaedia_entry][:link_ids] ||= []
    params[:encyclopaedia_entry][:music_track_ids] ||= []
    params[:encyclopaedia_entry][:picture_ids] ||= []
    params[:encyclopaedia_entry][:poem_ids] ||= []
    params[:encyclopaedia_entry][:quiz_ids] ||= []
    params[:encyclopaedia_entry][:resource_ids] ||= []
    params[:encyclopaedia_entry][:story_ids] ||= []
    params[:encyclopaedia_entry][:video_ids] ||= []
    if @encyclopaedia_entry.update_attributes(encyclopaedia_entry_params)
      flash[:notice] = 'Successfully updated encyclopaedia entry.'
      redirect_to_encyclopaedia_entry
    else
      render :edit
    end
  end

  def destroy
    @encyclopaedia_entry.destroy
    redirect_to(encyclopaedia_entries_path,
      notice: 'Successfully destroyed encyclopaedia entry.')
  end

  private

  def encyclopaedia_entry_params
    params.require(:encyclopaedia_entry).permit(
      policy(@encyclopaedia_entry || :encyclopaedia_entry).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :encyclopaedia_entry).order(:name)).resolve
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

  def redirect_to_encyclopaedia_entry
    if params[:continue_editing]
      redirect_to edit_encyclopaedia_entry_path(@encyclopaedia_entry)
    else
      redirect_to @encyclopaedia_entry
    end
  end
end
