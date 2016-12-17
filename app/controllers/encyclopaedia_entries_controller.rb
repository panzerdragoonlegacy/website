class EncyclopaediaEntriesController < ApplicationController
  include LoadableForEncyclopaediaEntry

  before_action :load_categories, except: [:index, :show, :destroy]
  before_action :load_encyclopaedia_entry, except: [:index, :new, :create]

  def index
    if params[:filter] == 'draft'
      load_draft_encyclopaedia_entries
    else
      load_category_groups
      @encyclopaedia_entries = policy_scope(
        EncyclopaediaEntry.order(:name).page(params[:page])
      )
    end
  end

  def show
    load_articles
    load_downloads
    load_links
    load_music_tracks
    load_pictures
    load_poems
    load_quizzes
    load_resources
    load_stories
    load_videos
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise 'Category not found.' unless category.present?
      @encyclopaedia_entry = EncyclopaediaEntry.new category: category
    else
      @encyclopaedia_entry = EncyclopaediaEntry.new
    end
    authorize @encyclopaedia_entry
  end

  def create
    @encyclopaedia_entry = EncyclopaediaEntry.new(encyclopaedia_entry_params)
    authorize @encyclopaedia_entry
    if @encyclopaedia_entry.save
      flash[:notice] = 'Successfully created encyclopaedia entry.'
      redirect_to_encyclopaedia_entry
    else
      render :new
    end
  end

  def update
    clear_empty_id_arrays
    if @encyclopaedia_entry.update_attributes(encyclopaedia_entry_params)
      flash[:notice] = 'Successfully updated encyclopaedia entry.'
      redirect_to_encyclopaedia_entry
    else
      render :edit
    end
  end

  def destroy
    @encyclopaedia_entry.destroy
    redirect_to(
      encyclopaedia_entries_path,
      notice: 'Successfully destroyed encyclopaedia entry.'
    )
  end

  private

  def encyclopaedia_entry_params
    params.require(:encyclopaedia_entry).permit(
      policy(@encyclopaedia_entry || :encyclopaedia_entry).permitted_attributes
    )
  end

  def clear_empty_id_arrays
    params[:encyclopaedia_entry][:contributor_profile_ids] ||= []
    params[:encyclopaedia_entry][:article_ids] ||= []
    params[:encyclopaedia_entry][:download_ids] ||= []
    params[:encyclopaedia_entry][:link_ids] ||= []
    params[:encyclopaedia_entry][:music_track_ids] ||= []
    params[:encyclopaedia_entry][:picture_ids] ||= []
    params[:encyclopaedia_entry][:poem_ids] ||= []
    params[:encyclopaedia_entry][:quiz_ids] ||= []
    params[:encyclopaedia_entry][:resource_ids] ||= []
    params[:encyclopaedia_entry][:story_ids] ||= []
    params[:encyclopaedia_entry][:video_ids] ||= []
  end

  def redirect_to_encyclopaedia_entry
    if params[:continue_editing]
      redirect_to edit_encyclopaedia_entry_path(@encyclopaedia_entry)
    else
      redirect_to @encyclopaedia_entry
    end
  end
end
