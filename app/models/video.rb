class Video < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Relatable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file(
    :mp4_video,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :mp4_video,
    presence: true,
    size: { in: 0..200.megabytes }
  )

  # There were issues specifying content types.
  do_not_validate_attachment_file_type :mp4_video

  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :mp4_video, file_name: "#{name.to_url}.mp4"
  end

  def to_param
    id.to_s + '-' + url
  end
end
