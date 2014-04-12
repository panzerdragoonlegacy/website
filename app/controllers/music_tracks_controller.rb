class MusicTracksController < ApplicationController

  before_filter :categories
  
  def index
    if params[:dragoon_id]
      raise "Dragoon not found." unless @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @music_tracks = policy_scope(MusicTrack.joins(:contributions).where(contributions: { dragoon_id: @dragoon.id }).order(:name).page(params[:page]))
    else
      @music_tracks = policy_scope(MusicTrack.order(:name).page(params[:page]))
    end
  end

  def show
    @music_track = MusicTrack.find_by_url(params[:id])
    authorize @music_track
  end

  def new
    @music_track = MusicTrack.new
    authorize @music_track
  end
  
  def create 
    @music_track = MusicTrack.new(music_track_params)
    authorize @music_track
    if @music_track.save
      redirect_to @music_track, notice: "Successfully created music track."
    else
      render :new
    end
  end

  def edit
    @music_track = MusicTrack.find_by_url(params[:id])
    authorize @music_track
  end
  
  def update
    @music_track = MusicTrack.find_by_url(music_track_params)
    authorize @music_track
    params[:music_track][:dragoon_ids] ||= []
    if @music_track.update_attributes(params[:music_track])
      redirect_to @music_track, notice: "Successfully updated music track."
    else
      render :edit
    end
  end

  def destroy
    @music_track = MusicTrack.find_by_url(params[:id])
    authorize @music_track
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

  def categories
    @categories = CategoryPolicy::Scope.new(current_user, Category.where(category_type: :music_track).order(:name)).resolve
  end

end
