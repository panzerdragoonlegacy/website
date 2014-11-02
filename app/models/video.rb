class Video < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Relatable
  include Sluggable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }
  
  has_attached_file :mp4_video,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"
  has_attached_file :webm_video,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"
  
  validates_attachment :mp4_video, presence: true,
    content_type: { content_type: "video/mp4" },
    size: { in: 0..50.megabytes }
  validates_attachment :webm_video, presence: true,
    content_type: { content_type: "video/webm" },
    size: { in: 0..50.megabytes }

  before_save :sync_filenames

  def sync_filenames
    sync_filename_of :mp4_video, filename: "#{self.name.to_url}.mp4"
    sync_filename_of :webm_video, filename: "#{self.name.to_url}.webm"
  end
end
