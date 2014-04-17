class ResourcesController < ApplicationController

  before_action :load_categories, except: [:show, :destroy]
  before_action :load_resource, except: [:index, :new, :create]
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
      @resources = policy_scope(Resource.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @resources = policy_scope(Resource.order(:name).page(params[:page]))
    end
  end

  def new
    @resource = Resource.new
    authorize @resource
  end
  
  def create 
    @resource = Resource.new(resource_params)
    authorize @resource
    if @resource.save
      flash[:notice] = "Successfully created resource."
      params[:continue_editing] ? redirect_to(edit_resource_path(@resource)) : redirect_to(@resource)
    else
      render :new
    end
  end

  def update
    params[:resource][:dragoon_ids] ||= []
    if @resource.update_attributes(resource_params)
      flash[:notice] = "Successfully updated resource."
      params[:continue_editing] ? redirect_to(edit_resource_path(@resource)) : redirect_to(@resource)
    else
      render :edit
    end
  end

  def destroy
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

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :resource).order(:name)).resolve
  end

  def load_resource
    @resource = Resource.find_by url: params[:id]
    authorize @resource
  end

end
