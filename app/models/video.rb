class Video < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Relatable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file :mp4_video,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"
  has_attached_file :webm_video,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_attachment :mp4_video, presence: true,
    content_type: { content_type: "video/mp4" },
    size: { in: 0..200.megabytes }
  validates_attachment :webm_video, presence: true,
    content_type: { content_type: "video/webm" },
    size: { in: 0..200.megabytes }

  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :mp4_video, file_name: "#{self.name.to_url}.mp4"
    sync_file_name_of :webm_video, file_name: "#{self.name.to_url}.webm"
  end

  def to_param
    id.to_s + '-' + url
  end
end
