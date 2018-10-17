class Video < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Taggable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file(
    :mp4_video,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )
  has_attached_file(
    :video_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      embedded: '280x280>'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :mp4_video,
    presence: true,
    size: { in: 0..500.megabytes }
  )
  validates_attachment(
    :video_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  # There were issues specifying content types.
  do_not_validate_attachment_file_type :mp4_video

  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :mp4_video, file_name: "#{name.to_url}.mp4"
    sync_file_name_of :video_picture, file_name: "#{name.to_url}.jpg"
  end

  def to_param
    id.to_s + '-' + url
  end
end
