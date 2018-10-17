class AddPicturesToMediaRecords < ActiveRecord::Migration
  def change
    add_column :downloads, :download_picture_file_name, :string
    add_column :downloads, :download_picture_content_type, :string
    add_column :downloads, :download_picture_file_size, :integer
    add_column :downloads, :download_picture_updated_at, :datetime

    add_column :music_tracks, :music_track_picture_file_name, :string
    add_column :music_tracks, :music_track_picture_content_type, :string
    add_column :music_tracks, :music_track_picture_file_size, :integer
    add_column :music_tracks, :music_track_picture_updated_at, :datetime

    add_column :videos, :video_picture_file_name, :string
    add_column :videos, :video_picture_content_type, :string
    add_column :videos, :video_picture_file_size, :integer
    add_column :videos, :video_picture_updated_at, :datetime
  end
end
