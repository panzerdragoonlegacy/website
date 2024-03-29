class Admin::PagesController < ApplicationController
  include FindBySlugConcerns
  include LoadableForPage
  include PreviewSlugConcerns
  layout 'admin'
  before_action :load_parent_pages, except: %i[index destroy]
  before_action :load_categories, except: [:destroy]
  before_action :load_page, except: %i[index new create]
  helper_method :custom_page_path

  def index
    clean_publish_false_param
    @q = Page.order(:name).ransack(params[:q])
    @pages = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    if params[:parent_page_id]
      parent_page = Page.find params[:parent_page_id]
      raise 'Parent page not found.' unless parent_page.present?
    end
    category = find_category_by_slug(params[:category]) if params[:category]
    @page = Page.new
    @page.category = category if category
    @page.parent_page_id = parent_page.id if parent_page
    @page.page_type = :literature_chapter.to_s if parent_page
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
    if @page.update page_params
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
    params.require(:page).permit(policy(@page || :page).permitted_attributes)
  end

  def redirect_to_page
    if params[:continue_editing]
      redirect_to edit_admin_page_path(@page)
    else
      redirect_to custom_page_path(@page)
    end
  end

  def custom_page_path(page)
    if page.page_type == :literature.to_s
      custom_path(page, literature_path(page))
    elsif page.page_type == :literature_chapter.to_s
      path = literature_chapter_path(page.parent_page.to_param, page.to_param)
      custom_path(page, path)
    else
      custom_path(page, top_level_page_path(page.slug))
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

  def load_categories
    @categories =
      CategoryPolicy::Scope.new(
        current_user,
        Category.where("category_type = 'literature'").order(:name)
      ).resolve
  end
end
