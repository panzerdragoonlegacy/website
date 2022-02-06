class AddTrackNumberToMusicTracks < ActiveRecord::Migration
  def change
    add_column :music_tracks, :track_number, :integer, default: 0
  end
end
