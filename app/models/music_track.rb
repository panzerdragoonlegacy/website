class MusicTrack < ActiveRecord::Base
  
  include Categorisable
  include Contributable
  include Relatable
  include Sluggable
    
  validates :track_number, presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 50 }
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file :mp3_music_track,
    path: ":rails_root/public/system/:attachment/:id/:style/:mp3_music_track_filename",
    url: "/system/:attachment/:id/:style/:mp3_music_track_filename"
  has_attached_file :ogg_music_track,
    path: ":rails_root/public/system/:attachment/:id/:style/:ogg_music_track_filename",
    url: "/system/:attachment/:id/:style/:ogg_music_track_filename"
  has_attached_file :flac_music_track,
    path: ":rails_root/public/system/:attachment/:id/:style/:flac_music_track_filename",
    url: "/system/:attachment/:id/:style/:flac_music_track_filename"

  validates_attachment :mp3_music_track, presence: true,
    content_type: { content_type: "audio/mp3" },
    size: { in: 0..25.megabytes }
  validates_attachment :ogg_music_track, presence: true,
    content_type: { content_type: "audio/ogg" },
    size: { in: 0..25.megabytes }
  validates_attachment :flac_music_track,
    size: { in: 0..50.megabytes }

  # There was an issue specifying a content type for FLAC files.
  do_not_validate_attachment_file_type :flac_music_track

  before_post_process :mp3_music_track_filename, :ogg_music_track_filename, :flac_music_track_filename
  
  # Sets mp3_music_track filename in the database.
  def mp3_music_track_filename
    if self.mp3_music_track_content_type == 'audio/mp3'
      self.mp3_music_track_file_name = self.name.to_url + ".mp3"
    end
  end
  
  # Sets ogg_music_track filename in the database.
  def ogg_music_track_filename
    if self.ogg_music_track_content_type == 'audio/ogg'
      self.ogg_music_track_file_name = self.name.to_url + ".ogg"
    end
  end
  
  # Sets flac_music_track filename in the database.
  def flac_music_track_filename
    self.flac_music_track_file_name = self.name.to_url + ".flac"
  end  
  
  # Sets mp3_music_track filename in the file system.
  Paperclip.interpolates :mp3_music_track_filename do |attachment, style|
    attachment.instance.mp3_music_track_filename
  end
  
  # Sets ogg_music_track filename in the file system.
  Paperclip.interpolates :ogg_music_track_filename do |attachment, style|
    attachment.instance.ogg_music_track_filename
  end
  
  # Sets flac_music_track filename in the file system.
  Paperclip.interpolates :flac_music_track_filename do |attachment, style|
    attachment.instance.flac_music_track_filename
  end

end
