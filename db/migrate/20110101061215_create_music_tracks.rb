class CreateMusicTracks < ActiveRecord::Migration
  def self.up
    create_table :music_tracks do |t|
      t.string :name
      t.string :url
      t.string :description
      t.text :information
      t.string :mp3_music_track_file_name
      t.string :mp3_music_track_content_type
      t.integer :mp3_music_track_file_size
      t.datetime :mp3_music_track_updated_at
      t.string :ogg_music_track_file_name
      t.string :ogg_music_track_content_type
      t.integer :ogg_music_track_file_size
      t.datetime :ogg_music_track_updated_at
      t.boolean :publish
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :music_tracks
  end
end
