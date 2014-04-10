class LinksController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @links = policy_scope(Link.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @links = policy_scope(Link.order(:name).page(params[:page]))
    end
  end

  def show
    @link = Link.find(params[:id])
    authorize @link
  end

  def new
    @link = Link.new
    authorize @link
  end
  
  def create 
    @link = Link.new(params[:link])
    authorize @link
    if @link.save
      redirect_to @link, notice: "Successfully created link."
    else
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
    authorize @link
  end
  
  def update
    @link = Link.find(params[:id])
    authorize @link
    params[:link][:dragoon_ids] ||= []
    if @link.update_attributes(params[:link])
      redirect_to @link, notice: "Successfully updated link."
    else
      render :edit
    end
  end

  def destroy
    @link = Link.find(params[:id])
    authorize @link
    @link.destroy
    redirect_to links_path, notice: "Successfully destroyed link."
  end
  
  private

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :link).order(:name)).resolve
  end

end
