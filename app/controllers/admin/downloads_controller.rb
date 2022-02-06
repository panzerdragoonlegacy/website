class Admin::DownloadsController < ApplicationController
  include LoadableForDownload
  include PreviewSlugConcerns
  layout 'admin'
  before_action :load_categories, except: %i[show destroy]
  before_action :load_download, except: %i[index new create]
  helper_method :custom_download_path

  def index
    clean_publish_false_param
    @q = Download.order(:name).ransack(params[:q])
    @downloads = policy_scope(@q.result.includes(:category).page(params[:page]))
  end

  def new
    if params[:category]
      category = find_category_by_slug params[:category]
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
    if @download.update download_params
      flash[:notice] = 'Successfully updated download.'
      redirect_to_download
    else
      render :edit
    end
  end

  def destroy
    @download.destroy
    redirect_to admin_downloads_path, notice: 'Successfully destroyed download.'
  end

  private

  def download_params
    params
      .require(:download)
      .permit(policy(@download || :download).permitted_attributes)
  end

  def redirect_to_download
    if params[:continue_editing]
      redirect_to edit_admin_download_path(@download)
    else
      redirect_to custom_download_path(@download)
    end
  end

  def custom_download_path(download)
    custom_path(download, download_path(download))
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
