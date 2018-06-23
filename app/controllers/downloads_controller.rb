class DownloadsController < ApplicationController
  include LoadableForDownload
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_download, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      load_contributors_downloads
    elsif params[:filter] == 'draft'
      load_draft_downloads
    else
      @downloads = policy_scope(Download.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(
      current_user,
      @download.encyclopaedia_entries.order(:name)
    ).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @download = Download.new category: category
    else
      @download = Download.new
    end
    authorize @download
  end

  def create
    make_current_user_a_contributor unless current_user.administrator?
    @download = Download.new download_params
    authorize @download
    if @download.save
      flash[:notice] = 'Successfully created download.'
      redirect_to_download
    else
      render :new
    end
  end

  def update
    params[:download][:contributor_profile_ids] ||= []
    make_current_user_a_contributor unless current_user.administrator?
    if @download.update_attributes download_params
      flash[:notice] = 'Successfully updated download.'
      redirect_to_download
    else
      render :edit
    end
  end

  def destroy
    @download.destroy
    redirect_to downloads_path, notice: 'Successfully destroyed download.'
  end

  private

  def download_params
    params.require(:download).permit(
      policy(@download || :download).permitted_attributes
    )
  end

  def redirect_to_download
    if params[:continue_editing]
      redirect_to edit_download_path(@download)
    else
      redirect_to(@download)
    end
  end

  def make_current_user_a_contributor
    unless current_user.contributor_profile_id.to_s.in?(
      params[:download][:contributor_profile_ids]
    )
      params[:download][:contributor_profile_ids] <<
        current_user.contributor_profile_id
    end
  end
end
