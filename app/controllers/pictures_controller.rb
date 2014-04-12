class PicturesController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @pictures = policy_scope(Picture.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @pictures = policy_scope(Picture.order(:name).page(params[:page]))
    end
  end

  def show
    @picture = Picture.find_by_url(params[:id])
    authorize @picture
  end

  def new
    @picture = Picture.new
    authorize @picture
  end
  
  def create 
    @picture = Picture.new(picture_params)
    authorize @picture
    if @picture.save
      redirect_to @picture, notice: "Successfully created picture."
    else
      render :new
    end
  end

  def edit
    @picture = Picture.find_by_url(params[:id])
    authorize @picture
  end
  
  def update
    @picture = Picture.find_by_url(params[:id])
    authorize @picture
    params[:picture][:dragoon_ids] ||= []
    if @picture.update_attributes(picture_params)
      redirect_to @picture, notice: "Successfully updated picture."
    else
      render :edit
    end
  end

  def destroy
    @picture = Picture.find_by_url(params[:id])
    authorize @picture
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

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :picture).order(:name)).resolve
  end

end
