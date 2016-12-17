class CategoriesController < ApplicationController
  include LoadableForCategory

  before_action :load_category_groups, except: [:index, :show, :destroy]
  before_action :load_category, except: [:index, :new, :create]

  def index
    if params[:filter] == 'draft'
      @categories = policy_scope(
        Category.where(publish: false).order(:name).page(params[:page])
      )
    else
      redirect_to site_map_path
    end
  end

  def show
    load_category_articles
    load_category_downloads
    load_category_encyclopaedia_entries
    load_category_links
    load_category_music_tracks
    load_category_pictures
    load_category_resources
    load_category_stories
    load_category_videos
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
      policy(@category || :category).permitted_attributes
    )
  end

  def redirect_to_category
    if params[:continue_editing]
      redirect_to edit_category_path(@category)
    else
      redirect_to @category
    end
  end
end
