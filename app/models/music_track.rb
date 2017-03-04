class MusicTrack < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Relatable
  include Syncable

  validates(
    :track_number,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 50
    }
  )
  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file(
    :mp3_music_track,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )
  has_attached_file(
    :ogg_music_track,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )
  has_attached_file(
    :flac_music_track,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :mp3_music_track,
    presence: true,
    content_type: { content_type: 'audio/mp3' },
    size: { in: 0..25.megabytes }
  )
  validates_attachment(
    :ogg_music_track,
    content_type: { content_type: 'audio/ogg' },
    size: { in: 0..25.megabytes }
  )
  validates_attachment :flac_music_track, size: { in: 0..50.megabytes }

  # There was an issue specifying a content type for FLAC files.
  do_not_validate_attachment_file_type :flac_music_track

  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :mp3_music_track, file_name: "#{name.to_url}.mp3"
    sync_file_name_of :ogg_music_track, file_name: "#{name.to_url}.ogg"
    sync_file_name_of :flac_music_track, file_name: "#{name.to_url}.flac"
  end

  def to_param
    id.to_s + '-' + url
  end
end
