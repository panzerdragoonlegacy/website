class VideosController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @videos = policy_scope(Video.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @videos = policy_scope(Video.order(:name).page(params[:page]))
    end
  end

  def show
    @video = Video.find_by_url(params[:id])
    authorize @video
  end

  def new
    @video = Video.new
    authorize @video
  end
  
  def create 
    @video = Video.new(video_params)
    authorize @video
    if @video.save
      redirect_to @video, notice: "Successfully created video."
    else
      render :new
    end
  end

  def edit
    @video = Video.find_by_url(params[:id])
    authorize @video
  end
  
  def update
    @video = Video.find_by_url(params[:id])
    authorize @video
    params[:video][:dragoon_ids] ||= []
    if @video.update_attributes(video_params)
      redirect_to @video, notice: "Successfully updated video."
    else
      render :edit
    end
  end

  def destroy
    @video = Video.find_by_url(params[:id])
    authorize @video
    @video.destroy
    redirect_to videos_path, notice: "Successfully destroyed video."
  end
  
  private

  def video_params
    params.require(:video).permit(
      :category_id,
      :name,
      :description,
      :information,
      :mp4_video,
      :webm_video,
      :youtube_video_id,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :video).order(:name)).resolve
  end

end
