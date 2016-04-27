class ResourcesController < ApplicationController
  before_action :load_categories, except: [:index, :show, :destroy]
  before_action :load_resource, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_resources
    elsif params[:filter] == 'draft'
      load_draft_resources
    else
      load_category_groups
      @resources = policy_scope(Resource.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @resource.encyclopaedia_entries.order(:name)
    ).resolve
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
    @resource = Resource.new(resource_params)
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
    if @resource.update_attributes(resource_params)
      flash[:notice] = 'Successfully updated resource.'
      redirect_to_resource
    else
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to resources_path, notice: 'Successfully destroyed resource.'
  end

  private

  def resource_params
    params.require(:resource).permit(
      policy(@resource || :resource).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :resource).order(:name)).resolve
  end

  def load_resource
    @resource = Resource.find_by url: params[:id]
    authorize @resource
  end

  def load_contributors_resources
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @resources = policy_scope(
      Resource.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_resources
    @resources = policy_scope(
      Resource.where(publish: false).order(:name).page(params[:page])
    )
  end

  def load_category_groups
    @category_groups = policy_scope(
      CategoryGroup.where(category_group_type: :resource).order(:name)
    )
  end

  def redirect_to_resource
    if params[:continue_editing]
      redirect_to edit_resource_path(@resource)
    else
      redirect_to @resource
    end
  end
end
