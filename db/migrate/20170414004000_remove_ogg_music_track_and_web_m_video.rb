class RemoveOggMusicTrackAndWebMVideo < ActiveRecord::Migration
  def up
    remove_column :music_tracks, :ogg_music_track_file_name
    remove_column :music_tracks, :ogg_music_track_content_type
    remove_column :music_tracks, :ogg_music_track_file_size
    remove_column :music_tracks, :ogg_music_track_updated_at

    remove_column :videos, :webm_video_file_name
    remove_column :videos, :webm_video_content_type
    remove_column :videos, :webm_video_file_size
    remove_column :videos, :webm_video_updated_at
  end

  def down
    add_column :videos, :webm_video_file_name, :string
    add_column :videos, :webm_video_content_type, :string
    add_column :videos, :webm_video_file_size, :integer
    add_column :videos, :webm_video_updated_at, :datetime

    add_column :music_tracks, :ogg_music_track_file_name, :string
    add_column :music_tracks, :ogg_music_track_content_type, :string
    add_column :music_tracks, :ogg_music_track_file_size, :integer
    add_column :music_tracks, :ogg_music_track_updated_at, :datetime
  end
end
