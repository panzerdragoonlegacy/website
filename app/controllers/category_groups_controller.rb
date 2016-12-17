class CategoryGroupsController < ApplicationController
  before_action :load_category_group, except: [:new, :create]

  def new
    @category_group = CategoryGroup.new(
      category_group_type: params[:category_group_type]
    )
    authorize @category_group
  end

  def create
    @category_group = CategoryGroup.new(category_group_params)
    authorize @category_group
    if @category_group.save
      flash[:notice] = 'Successfully created category group.'
      redirect_to_category_group
    else
      render :new
    end
  end

  def update
    if @category_group.update_attributes(category_group_params)
      flash[:notice] = 'Successfully updated category group.'
      redirect_to_category_group
    else
      render :edit
    end
  end

  def destroy
    @category_group.destroy
    redirect_to(
      site_map_path,
      notice: 'Successfully destroyed category group.'
    )
  end

  private

  def category_group_params
    params.require(:category_group).permit(
      :name,
      :category_group_type
    )
  end

  def load_category_group
    @category_group = CategoryGroup.find_by url: params[:id]
    authorize @category_group
  end

  def redirect_to_category_group
    if params[:continue_editing]
      redirect_to edit_category_group_path(@category_group)
    else
      redirect_to site_map_path
    end
  end
end
