class AddFlacMusicTrackToMusicTrack < ActiveRecord::Migration
  def change
    add_column :music_tracks, :flac_music_track_file_name, :string
    add_column :music_tracks, :flac_music_track_content_type, :string
    add_column :music_tracks, :flac_music_track_file_size, :integer
    add_column :music_tracks, :flac_music_track_updated_at, :datetime
  end
end
