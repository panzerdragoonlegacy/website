class VideosController < ApplicationController
  before_action :load_categories, expect: [:index, :show, :destroy]
  before_action :load_video, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_videos
    elsif params[:filter] == 'draft'
      load_draft_videos
    else
      load_category_groups
      @videos = policy_scope(Video.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @video.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @video = Video.new category: category
    else
      @video = Video.new
    end
    authorize @video
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @video = Video.new video_params
    authorize @video
    if @video.save
      flash[:notice] = 'Successfully created video.'
      redirect_to_video
    else
      render :new
    end
  end

  def update
    params[:video][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @video.update_attributes video_params
      flash[:notice] = 'Successfully updated video.'
      redirect_to_video
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to videos_path, notice: 'Successfully destroyed video.'
  end

  private

  def video_params
    params.require(:video).permit(
      policy(@video || :video).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :video).order(:name)
    ).resolve
  end

  def load_video
    @video = Video.find params[:id]
    authorize @video
  end

  def load_contributors_videos
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @videos = policy_scope(
      Video.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_videos
    @videos = policy_scope(
      Video.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :video).order(:name)
    )
  end

  def redirect_to_video
    if params[:continue_editing]
      redirect_to edit_video_path(@video)
    else
      redirect_to @video
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:video][:contributor_profile_ids]
    )
      params[:video][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
