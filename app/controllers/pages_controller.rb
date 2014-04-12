class PagesController < ApplicationController
  
  def index
    @pages = policy_scope(Page.order(:name).page(params[:page]))
  end
  
  def show
    @page = Page.find_by_url(params[:id])
    authorize @page
  end

  def new
    @page = Page.new
    authorize @page
  end

  def create 
    @page = Page.new(page_params)
    authorize @page
    if @page.save
      redirect_to @page, notice: "Successfully created page."
    else
      render :new
    end
  end

  def edit
    @page = Page.find_by_url(params[:id])
    authorize @page
  end
  
  def update
    @page = Page.find_by_url(params[:id])
    authorize @page
    if @page.update_attributes(page_params)
      redirect_to @page, notice: "Successfully updated page."
    else
      render :edit
    end
  end

  def destroy
    @page = Page.find_by_url(params[:id])
    authorize @page
    @page.destroy
    redirect_to pages_path, notice: "Successfully destroyed page."
  end

  private

  def page_params
    params.require(:page).permit(
      :name,
      :content,
      :publish,
      illustrations_attributes: [:id, :illustration, :_destroy]
    )
  end

end
