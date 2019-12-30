class Admin::PagesController < ApplicationController
  include LoadableForPage
  layout 'admin'
  before_action :load_parent_pages, except: [:index, :destroy]
  before_action :load_categories, except: [:destroy]
  before_action :load_page, except: [:index, :new, :create]

  def index
    clean_publish_false_param
    @q = Page.order(:name).ransack(params[:q])
    @pages = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    if params[:parent_page_id]
      parent_page = Page.find_by id: params[:parent_page_id]
      raise 'Parent page not found.' unless parent_page.present?
    end
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
    end
    @page = Page.new
    @page.category = category if category
    @page.parent_page_id = parent_page.id if parent_page
    authorize @page
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @page = Page.new page_params
    authorize @page
    if @page.save
      flash[:notice] = 'Successfully created page.'
      redirect_to_page
    else
      render :new
    end
  end

  def update
    params[:page][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @page.update_attributes page_params
      flash[:notice] = 'Successfully updated page.'
      redirect_to_page
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to admin_pages_path, notice: 'Successfully destroyed page.'
  end

  private

  def page_params
    params.require(:page).permit(
      policy(@page || :page).permitted_attributes
    )
  end

  def redirect_to_page
    if params[:continue_editing]
      redirect_to edit_admin_page_path(@page)
    else
      redirect_to literature_path(@page)
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:page][:contributor_profile_ids]
    )
      params[:page][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
