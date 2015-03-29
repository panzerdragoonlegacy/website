class DownloadsController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_download, except: [:index, :new, :create]

  def index
    if params[:dragoon_id]
      unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
        raise "Dragoon not found."
      end
      @downloads = policy_scope(Download.joins(:contributions).where(
        contributions: { dragoon_id: @dragoon.id }).order(:name).page(
        params[:page]))
    else
      @downloads = policy_scope(Download.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(current_user,
      @download.encyclopaedia_entries.order(:name)).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise "Category not found." unless category.present?
      @download = Download.new category: category
    else
      @download = Download.new
    end
    authorize @download
  end

  def create
    @download = Download.new(download_params)
    authorize @download
    if @download.save
      flash[:notice] = "Successfully created download."
      if params[:continue_editing]
        redirect_to edit_download_path(@download)
      else
        redirect_to(@download)
      end
    else
      render :new
    end
  end

  def update
    params[:download][:dragoon_ids] ||= []
    if @download.update_attributes(download_params)
      flash[:notice] = "Successfully updated download."
      if params[:continue_editing]
        redirect_to edit_download_path(@download)
      else
        redirect_to @download
      end
    else
      render :edit
    end
  end

  def destroy
    @download.destroy
    redirect_to downloads_path, notice: "Successfully destroyed download."
  end

  private

  def download_params
    params.require(:download).permit(
      :category_id,
      :name,
      :description,
      :download,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user,
      Category.where(category_type: :download).order(:name)).resolve
  end

  def load_download
    @download = Download.find_by url: params[:id]
    authorize @download
  end
end
