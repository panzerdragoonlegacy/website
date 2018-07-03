class Admin::CategoriesController < ApplicationController
  include LoadableForCategory
  include Sortable
  layout 'admin'
  before_action :load_category_groups, except: [:index, :destroy]
  before_action :load_category, except: [:index, :new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @categories = policy_scope(
      Category.order(sort_column + ' ' + sort_direction).page(params[:page])
    )
  end

  def new
    @category = Category.new category_type: params[:category_type]
    authorize @category
  end

  def create
    @category = Category.new category_params
    authorize @category
    if @category.save
      flash[:notice] = 'Successfully created category.'
      redirect_to_category
    else
      render :new
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:notice] = 'Successfully updated category.'
      redirect_to_category
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_to(
      admin_categories_path,
      notice: 'Successfully destroyed category.'
    )
  end

  private

  def category_params
    params.require(:category).permit(
      policy(@category || :category).permitted_attributes
    )
  end

  def redirect_to_category
    if params[:continue_editing]
      redirect_to edit_admin_category_path(@category)
    else
      redirect_to @category
    end
  end

  def sort_column
    Category.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
end
