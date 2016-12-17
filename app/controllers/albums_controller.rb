class AlbumsController < ApplicationController
  before_action :load_categories, except: [:index, :destroy]
  before_action :load_album, except: [:index, :new, :create]

  def index
    @albums = policy_scope(Album.order(:name).page(params[:page]))
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @album = Album.new category: category
    else
      @album = Album.new
    end
    authorize @album
  end

  def create
    @album = Album.new album_params
    authorize @album
    if @album.save
      flash[:notice] = 'Successfully created album.'
      redirect_to_album_or_category
    else
      render :new
    end
  end

  def update
    params[:album][:contributor_profile_ids] ||= []
    if @album.update_attributes album_params
      flash[:notice] = 'Successfully updated album.'
      redirect_to_album_or_category
    else
      render :edit
    end
  end

  def destroy
    @album.destroy
    redirect_to pictures_path, notice: 'Successfully destroyed album.'
  end

  private

  def album_params
    params.require(:album).permit(
      policy(@album || :album).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :picture).order(:name)
    ).resolve
  end

  def load_album
    @album = Album.find params[:id]
    authorize @album
  end

  def redirect_to_album_or_category
    if params[:continue_editing]
      redirect_to edit_album_path(@album)
    else
      redirect_to @album.category
    end
  end
end
