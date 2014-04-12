class ResourcesController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @resources = policy_scope(Resource.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @resources = policy_scope(Resource.order(:name).page(params[:page]))
    end
  end

  def show
    @resource = Resource.find_by_url(params[:id])
    authorize @resource
  end

  def new
    @resource = Resource.new
    authorize @resource
  end
  
  def create 
    @resource = Resource.new(resource_params)
    authorize @resource
    if @resource.save
      redirect_to @resource, notice: "Successfully created resource."
    else
      render :new
    end
  end

  def edit
    @resource = Resource.find_by_url(params[:id])
    authorize @resource
  end
  
  def update
    @resource = Resource.find_by_url(params[:id])
    authorize @resource
    params[:resource][:dragoon_ids] ||= []
    if @resource.update_attributes(resource_params)
      redirect_to @resource, notice: "Successfully updated resource."
    else
      render :edit
    end
  end

  def destroy
    @resource = Resource.find_by_url(params[:id])
    authorize @resource
    @resource.destroy
    redirect_to resources_path, notice: "Successfully destroyed resource."
  end
  
  private

  def resource_params
    params.require(:resource).permit(
      :category_id,
      :name,
      :content,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: [],
      illustrations_attributes: [:id, :illustration, :_destroy]
    )
  end

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :resource).order(:name)).resolve
  end

end
