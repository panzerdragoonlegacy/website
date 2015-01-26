class PicturesController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_picture, except: [:index, :new, :create]

  def index
    if params[:dragoon_id]
      unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
        raise "Dragoon not found."
      end
      @pictures = policy_scope(Picture.joins(:contributions).where(
        contributions: { dragoon_id: @dragoon.id }).order(:name).page(
        params[:page]))
    else
      @pictures = policy_scope(Picture.order(:name).page(params[:page]))
    end
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise "Category not found." unless category.present?
      @picture = Picture.new category: category
    else
      @picture = Picture.new
    end
    authorize @picture
  end

  def create
    @picture = Picture.new(picture_params)
    authorize @picture
    if @picture.save
      flash[:notice] = "Successfully created picture."
      if params[:continue_editing]
        redirect_to edit_picture_path(@picture)
      else
        redirect_to @picture
      end
    else
      render :new
    end
  end

  def update
    params[:picture][:dragoon_ids] ||= []
    if @picture.update_attributes(picture_params)
      flash[:notice] = "Successfully updated picture."
      if params[:continue_editing]
        redirect_to edit_picture_path(@picture)
      else
        redirect_to @picture
      end
    else
      render :edit
    end
  end

  def destroy
    @picture.destroy
    redirect_to pictures_path, notice: "Successfully destroyed picture."
  end

  private

  def picture_params
    params.require(:picture).permit(
      :category_id,
      :name,
      :description,
      :information,
      :picture,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :picture).order(:name)).resolve
  end

  def load_picture
    @picture = Picture.find_by url: params[:id]
    authorize @picture
  end
end
