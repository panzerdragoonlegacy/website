class Admin::ResourcesController < ApplicationController
  include LoadableForResource
  include Sortable
  layout 'admin'
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_resource, except: [:index, :new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @resources = policy_scope(
      Resource.order(sort_column + ' ' + sort_direction).page(params[:page])
    )
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @resource = Resource.new category: category
    else
      @resource = Resource.new
    end
    authorize @resource
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @resource = Resource.new resource_params
    authorize @resource
    if @resource.save
      flash[:notice] = 'Successfully created resource.'
      redirect_to_resource
    else
      render :new
    end
  end

  def update
    params[:resource][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @resource.update_attributes resource_params
      flash[:notice] = 'Successfully updated resource.'
      redirect_to_resource
    else
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to admin_resources_path, notice: 'Successfully destroyed resource.'
  end

  private

  def resource_params
    params.require(:resource).permit(
      policy(@resource || :resource).permitted_attributes
    )
  end

  def redirect_to_resource
    if params[:continue_editing]
      redirect_to edit_admin_resource_path(@resource)
    else
      redirect_to @resource
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:resource][:contributor_profile_ids]
    )
      params[:resource][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end

  def sort_column
    Resource.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
end
