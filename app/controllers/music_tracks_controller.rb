class MusicTracksController < ApplicationController
  before_filter :categories
  load_resource :find_by => :url
  authorize_resource

  def index
    if params[:dragoon_id]
      @dragoon = Dragoon.find_by_url(params[:dragoon_id])
      @music_tracks = MusicTrack.accessible_by(current_ability).joins(:contributions).where(:contributions => {:dragoon_id => @dragoon.id}).order(:track_number).page(params[:page])
      @title = @dragoon.name + "'s Music"
    else
      @music_tracks = MusicTrack.accessible_by(current_ability).order(:name).page(params[:page])
      @title = "Music"
    end
  end

  def show
    @commentable = @music_track
    @comment = Comment.new
    session[:redirect_path] = request.fullpath
    @emoticons = Emoticon.order(:name)
  end

  def create 
    @music_track = MusicTrack.new(params[:music_track])
    if @music_track.save
      redirect_to @music_track, :notice => "Successfully created music track."
    else
      render 'new'
    end
  end
  
  def update
    params[:music_track][:dragoon_ids] ||= []
    if @music_track.update_attributes(params[:music_track])
      redirect_to @music_track, :notice => "Successfully updated music track."
    else
      render 'edit'
    end
  end

  def destroy
    @music_track.destroy
    redirect_to music_tracks_path, :notice => "Successfully destroyed music track."
  end

private

  def categories
    @categories = Category.accessible_by(current_ability).where(:category_type => :music_track).order(:name)
  end
end