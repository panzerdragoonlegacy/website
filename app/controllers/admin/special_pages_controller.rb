class Admin::SpecialPagesController < ApplicationController
  include LoadableForSpecialPage
  layout 'admin'
  before_action :load_special_page, except: [:index, :new, :create]

  def index
    clean_publish_false_param
    @q = SpecialPage.order(:name).ransack(params[:q])
    @special_pages = policy_scope(@q.result.page(params[:special_page]))
  end

  def new
    @special_page = SpecialPage.new
    authorize @special_page
  end

  def create
    @special_page = SpecialPage.new special_page_params
    authorize @special_page
    if @special_page.save
      flash[:notice] = 'Successfully created special page.'
      redirect_to_special_page
    else
      render :new
    end
  end

  def update
    if @special_page.update_attributes special_page_params
      flash[:notice] = 'Successfully updated special page.'
      redirect_to_special_page
    else
      render :edit
    end
  end

  def destroy
    @special_page.destroy
    redirect_to(
      admin_special_pages_path,
      notice: 'Successfully destroyed special page.'
    )
  end

  private

  def special_page_params
    params.require(:special_page).permit(
      policy(@special_page || :special_page).permitted_attributes
    )
  end

  def redirect_to_special_page
    if params[:continue_editing]
      redirect_to edit_admin_special_page_path(@special_page)
    else
      redirect_to @special_page
    end
  end
end
