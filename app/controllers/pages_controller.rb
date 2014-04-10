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
    @page = Page.new(params[:page])
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
    if @page.update_attributes(params[:page])
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

end
