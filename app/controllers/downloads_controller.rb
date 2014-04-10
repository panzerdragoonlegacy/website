class DownloadsController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @downloads = policy_scope(Download.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @downloads = policy_scope(Download.order(:name).page(params[:page]))
    end
  end

  def show
    @download = Download.find_by_url(params[:id])
    authorize @download
  end

  def new
    @download = Download.new
    authorize @download
  end
  
  def create 
    @download = Download.new(params[:download])
    authorize @download
    if @download.save
      redirect_to @download, notice: "Successfully created download."
    else
      render :new
    end
  end

  def edit
    @download = Download.find_by_url(params[:id])
    authorize @download
  end
  
  def update
    @download = Download.find_by_url(params[:id])
    authorize @download
    params[:download][:dragoon_ids] ||= []
    if @download.update_attributes(params[:download])
      redirect_to @download, notice: "Successfully updated download."
    else
      render :edit
    end
  end

  def destroy
    @download = Download.find_by_url(params[:id])
    authorize @download
    @download.destroy
    redirect_to downloads_path, notice: "Successfully destroyed download."
  end
  
  private

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :download).order(:name)).resolve
  end

end
