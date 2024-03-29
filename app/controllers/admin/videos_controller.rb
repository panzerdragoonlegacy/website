class Admin::VideosController < ApplicationController
  include FindBySlugConcerns
  include LoadableForAlbumable
  include LoadableForVideo
  include PreviewSlugConcerns
  layout 'admin'
  before_action :load_albums, except: %i[index destroy]
  before_action :load_categories, except: %i[show destroy]
  before_action :load_video, except: %i[index new create]
  helper_method :custom_video_path

  def index
    clean_publish_false_param
    @q = Video.order(:name).ransack(params[:q])
    @videos = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    if params[:category]
      category = find_category_by_slug params[:category]
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
    if @video.update video_params
      flash[:notice] = 'Successfully updated video.'
      redirect_to_video
    else
      render :edit
    end
  end

  def destroy
    @video.destroy
    redirect_to(admin_videos_path, notice: 'Successfully destroyed video.')
  end

  private

  def video_params
    params.require(:video).permit(policy(@video || :video).permitted_attributes)
  end

  def redirect_to_video
    if params[:continue_editing]
      redirect_to edit_admin_video_path(@video)
    else
      redirect_to custom_video_path(@video)
    end
  end

  def custom_video_path(video)
    custom_path(video, video_path(video))
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
             params[:video][:contributor_profile_ids]
           )
      params[:video][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end

  def sort_column
    Video.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
end
