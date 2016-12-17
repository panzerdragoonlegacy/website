class PicturesController < ApplicationController
  include LoadableForPicture

  before_action :load_replaceable_pictures, except: [:index, :show, :destroy]
  before_action :load_categories, except: [:index, :show, :destroy]
  before_action :load_picture, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_pictures
    elsif params[:filter] == 'draft'
      load_draft_pictures
    else
      load_category_groups
      @pictures = policy_scope(Picture.order(:name).page(params[:page]))
    end
  end

  def show
    load_picture_to_replace
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @picture.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @picture = Picture.new category: category
    else
      @picture = Picture.new
    end
    authorize @picture
  end

  def create
    @picture = Picture.new picture_params
    authorize @picture
    if @picture.save
      flash[:notice] = 'Successfully created picture.'
      redirect_to_picture
    else
      render :new
    end
  end

  def update
    params[:picture][:contributor_profile_ids] ||= []
    if @picture.update_attributes picture_params
      flash[:notice] = 'Successfully updated picture.'
      redirect_to_picture
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice: 'Successfully destroyed picture.'
  end

  private

  def picture_params
    params.require(:picture).permit(
      policy(@picture || :picture).permitted_attributes
    )
  end

  def redirect_to_picture
    if params[:continue_editing]
      redirect_to edit_picture_path(@picture)
    else
      redirect_to @picture
    end
  end
end
