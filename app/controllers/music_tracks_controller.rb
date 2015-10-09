class MusicTracksController < ApplicationController
  before_action :load_categories, except: [:index, :show, :destroy]
  before_action :load_music_track, except: [:index, :new, :create]

  def index
    if params[:contributor_profile_id]
      unless @contributor_profile = ContributorProfile.find_by(
        url: params[:contributor_profile_id])
        raise "Contributor profile not found."
      end
      @music_tracks = policy_scope(MusicTrack.joins(:contributions).where(
        contributions: { contributor_profile_id: @contributor_profile.id }).
        order(:name).page(params[:page]))
    elsif params[:filter] == 'draft'
      @music_tracks = policy_scope(MusicTrack.where(publish: false).
        order(:name).page(params[:page]))
    else
      @category_groups = policy_scope(CategoryGroup.where(
        category_group_type: :music_track).order(:name))
      @music_tracks = policy_scope(MusicTrack.order(:name).page(params[:page]))
    end
  end

  def show
    @encyclopaedia_entries = EncyclopaediaEntryPolicy::Scope.new(current_user,
      @music_track.encyclopaedia_entries.order(:name)).resolve
  end

  def new
    if params[:category]
      category = Category.find_by url: params[:category]
      raise "Category not found." unless category.present?
      @music_track = MusicTrack.new category: category
    else
      @music_track = MusicTrack.new
    end
    authorize @music_track
  end

  def create
    @music_track = MusicTrack.new(music_track_params)
    authorize @music_track
    if @music_track.save
      flash[:notice] = "Successfully created music track."
      if params[:continue_editing]
        redirect_to edit_music_track_path(@music_track)
      else
        redirect_to @music_track
      end
    else
      render :new
    end
  end

  def update
    params[:music_track][:contributor_profile_ids] ||= []
    if @music_track.update_attributes(music_track_params)
      flash[:notice] = "Successfully updated music track."
      if params[:continue_editing]
        redirect_to edit_music_track_path(@music_track)
      else
        redirect_to @music_track
      end
    else
      render :edit
    end
  end

  def destroy
    @music_track.destroy
    redirect_to music_tracks_path, notice: "Successfully destroyed music track."
  end

  private

  def music_track_params
    params.require(:music_track).permit(
      policy(@music_track || :music_track).permitted_attributes
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(
      category_type: :music_track).order(:name)).resolve
  end

  def load_music_track
    @music_track = MusicTrack.find_by url: params[:id]
    authorize @music_track
  end
end
