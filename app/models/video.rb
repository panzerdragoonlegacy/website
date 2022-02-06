class Video < ApplicationRecord
  include Categorisable
  include Contributable
  include Publishable
  include Taggable
  include SluggableWithId
  include Syncable

  has_paper_trail

  belongs_to :album, optional: true

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }
  validates(
    :sequence_number,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 999
    }
  )

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
    size: {
      in: 0..500.megabytes
    }
  )
  validates_attachment(
    :video_picture,
    content_type: {
      content_type: 'image/jpeg'
    },
    size: {
      in: 0..5.megabytes
    }
  )

  # There were issues specifying content types.
  do_not_validate_attachment_file_type :mp4_video

  before_save :set_published_at
  before_save :set_slug
  before_save :sync_file_names
  before_save :strip_youtube_url_to_just_id

  def sync_file_names
    sync_file_name_of :mp4_video, file_name: "#{slug_from_name}.mp4"
    sync_file_name_of :video_picture, file_name: "#{slug_from_name}.jpg"
  end

  private

  def strip_youtube_url_to_just_id
    if self.youtube_video_id
      self.youtube_video_id =
        self.youtube_video_id.sub('https://www.youtube.com/watch?v=', '')
    end
  end
end
