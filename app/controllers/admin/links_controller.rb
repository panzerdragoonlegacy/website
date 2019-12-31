class Admin::LinksController < ApplicationController
  layout 'admin'
  before_action :load_link, except: [:index, :new, :create]

  def index
    @q = Link.order(:name).ransack(params[:q])
    @links = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    @link = Link.new
    authorize @link
  end

  def create
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

  def load_link
    @link = Link.find_by id: params[:id]
    authorize @link
  end
end
