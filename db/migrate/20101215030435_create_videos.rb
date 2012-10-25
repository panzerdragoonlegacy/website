class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :name
      t.string :url
      t.string :description
      t.text :information
      t.string :mp4_video_file_name
      t.string :mp4_video_content_type
      t.integer :mp4_video_file_size
      t.datetime :mp4_video_updated_at
      t.string :webm_video_file_name
      t.string :webm_video_content_type
      t.integer :webm_video_file_size
      t.datetime :webm_video_updated_at
      t.boolean :publish
      t.references :category
      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end