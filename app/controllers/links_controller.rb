class LinksController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_link, except: [:index, :new, :create]

  def index
    if params[:dragoon_id]
      unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
        raise "Dragoon not found."
      end
      @links = policy_scope(Link.joins(:contributions).where(
        contributions: { dragoon_id: @dragoon.id }).order(:name).page(
        params[:page]))
    else
      @links = policy_scope(Link.order(:name).page(params[:page]))
    end
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise "Category not found." unless category.present?
      @link = Link.new category: category
    else
      @link = Link.new
    end
    authorize @link
  end

  def create
    @link = Link.new(link_params)
    authorize @link
    if @link.save
      flash[:notice] = "Successfully created link."
      if params[:continue_editing]
        redirect_to edit_link_path(@link)
      else
        redirect_to links_path
      end
    else
      render :new
    end
  end

  def update
    params[:link][:dragoon_ids] ||= []
    if @link.update_attributes(link_params)
      flash[:notice] = "Successfully updated link."
      if params[:continue_editing]
        redirect_to edit_link_path(@link)
      else
        redirect_to links_path
      end
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to links_path, notice: "Successfully destroyed link."
  end

  private

  def link_params
    params.require(:link).permit(
      :category_id,
      :name,
      :url,
      :partner_site,
      :description,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :link).order(:name)).resolve
  end

  def load_link
    @link = Link.find params[:id]
    authorize @link
  end
end
