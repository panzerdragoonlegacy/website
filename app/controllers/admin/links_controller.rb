class Admin::LinksController < ApplicationController
  include LoadableForLink
  layout 'admin'
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_link, except: [:index, :new, :create]

  def index
    @q = Link.order(:name).ransack(params[:q])
    @links = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @link = Link.new category: category
    else
      @link = Link.new
    end
    authorize @link
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @link = Link.new link_params
    authorize @link
    if @link.save
      flash[:notice] = 'Successfully created link.'
      redirect_to_link
    else
      render :new
    end
  end

  def update
    params[:link][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @link.update_attributes link_params
      flash[:notice] = 'Successfully updated link.'
      redirect_to_link
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to admin_links_path, notice: 'Successfully destroyed link.'
  end

  private

  def link_params
    params.require(:link).permit(
      policy(@link || :link).permitted_attributes
    )
  end

  def redirect_to_link
    if params[:continue_editing]
      redirect_to edit_admin_link_path(@link)
    else
      redirect_to admin_links_path
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:link][:contributor_profile_ids]
    )
      params[:link][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
