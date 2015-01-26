class VideosController < ApplicationController
  before_action :load_categories, expect: [:show, :destroy]
  before_action :load_video, except: [:index, :new, :create]

  def index
    if params[:dragoon_id]
      unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
        raise "Dragoon not found."
      end
      @videos = policy_scope(Video.joins(:contributions).where(
        contributions: { dragoon_id: @dragoon.id }).order(:name).page(
        params[:page]))
    else
      @videos = policy_scope(Video.order(:name).page(params[:page]))
    end
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise "Category not found." unless category.present?
      @video = Video.new category: category
    else
      @video = Video.new
    end
    authorize @video
  end

  def create
    @video = Video.new(video_params)
    authorize @video
    if @video.save
      flash[:notice] = "Successfully created video."
      if params[:continue_editing]
        redirect_to edit_video_path(@video)
      else
        redirect_to @video
      end
    else
      render :new
    end
  end

  def update
    params[:video][:dragoon_ids] ||= []
    if @video.update_attributes(video_params)
      flash[:notice] = "Successfully updated video."
      if params[:continue_editing]
        redirect_to edit_video_path(@video)
      else
        redirect_to @video
      end
    else
      render :edit
    end
  end

  def destroy
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

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :video).order(:name)).resolve
  end

  def load_video
    @video = Video.find_by url: params[:id]
    authorize @video
  end
end
