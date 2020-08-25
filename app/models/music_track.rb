class MusicTrack < ApplicationRecord
  include Categorisable
  include Contributable
  include Publishable
  include Taggable
  include SluggableWithId
  include Syncable

  has_paper_trail

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
    :flac_music_track,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )
  has_attached_file(
    :music_track_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      embedded: '280x280>'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :mp3_music_track,
    presence: true,
    size: { in: 0..25.megabytes }
  )
  validates_attachment :flac_music_track, size: { in: 0..50.megabytes }
  validates_attachment(
    :music_track_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  # There were issues specifying content types.
  do_not_validate_attachment_file_type :mp3_music_track
  do_not_validate_attachment_file_type :flac_music_track

  before_save :set_published_at
  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :mp3_music_track, file_name: "#{name.to_url}.mp3"
    sync_file_name_of :flac_music_track, file_name: "#{name.to_url}.flac"
    sync_file_name_of :music_track_picture, file_name: "#{name.to_url}.jpg"
  end
end
