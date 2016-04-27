class DownloadsController < ApplicationController
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
    @download = Download.new(download_params)
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
    if @download.update_attributes(download_params)
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

  def load_categories
    @categories = CategoryPolicy::Scope.new(
      current_user,
      Category.where(category_type: :download).order(:name)
    ).resolve
  end

  def load_download
    @download = Download.find_by url: params[:id]
    authorize @download
  end

  def load_contributors_downloads
    @contributor_profile = ContributorProfile.find_by(
      url: params[:contributor_profile_id]
    )
    raise 'Contributor profile not found.' unless @contributor_profile
    @downloads = policy_scope(
      Download.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }
      ).order(:name).page(params[:page])
    )
  end

  def load_draft_downloads
    @downloads = policy_scope(
      Download.where(publish: false).order(:name).page(params[:page])
    )
  end

  def redirect_to_download
    if params[:continue_editing]
      redirect_to edit_download_path(@download)
    else
      redirect_to(@download)
    end
  end
end
