class MusicTracksController < ApplicationController
  before_action :load_categories, except: [:show, :destroy]
  before_action :load_music_track, except: [:index, :new, :create]
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by(url: params[:dragoon_id])
      @music_tracks = policy_scope(MusicTrack.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @music_tracks = policy_scope(MusicTrack.order(:name).page(params[:page]))
    end
  end

  def new
    @music_track = MusicTrack.new
    authorize @music_track
  end
  
  def create 
    @music_track = MusicTrack.new(music_track_params)
    authorize @music_track
    if @music_track.save
      flash[:notice] = "Successfully created music track."
      params[:continue_editing] ? redirect_to(edit_music_track_path(@music_track)) : redirect_to(@music_track)
    else
      render :new
    end
  end

  def update
    params[:music_track][:dragoon_ids] ||= []
    if @music_track.update_attributes(music_track_params)
      flash[:notice] = "Successfully updated music track."
      params[:continue_editing] ? redirect_to(edit_music_track_path(@music_track)) : redirect_to(@music_track)
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
      :category_id,
      :track_number,
      :name,
      :description,
      :information,
      :mp3_music_track,
      :ogg_music_track,
      :flac_music_track,
      :publish,
      dragoon_ids: [],
      encyclopaedia_entry_ids: []
    )
  end

  def load_categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :music_track).order(:name)).resolve
  end

  def load_music_track
    @music_track = MusicTrack.find_by url: params[:id]
    authorize @music_track
  end
end
