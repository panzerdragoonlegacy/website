class Admin::PagesController < ApplicationController
  include LoadableForPage
  include Sortable
  layout 'admin'
  before_action :load_page, except: [:index, :new, :create]
  helper_method :sort_column, :sort_direction

  def index
    @pages = policy_scope(
      Page.order(sort_column + ' ' + sort_direction).page(params[:page])
    )
  end

  def new
    @page = Page.new
    authorize @page
  end

  def create
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
      redirect_to @page
    end
  end

  def sort_column
    Page.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
end
