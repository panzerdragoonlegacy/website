class ContributorProfile < ActiveRecord::Base
  include Sluggable

  has_one :user, dependent: :destroy
  has_many :news_entries, dependent: :destroy
  
  has_many :contributions, dependent: :destroy
  has_many :articles, through: :contributions, source: :contributable, 
    source_type: 'Article'
  has_many :downloads, through: :contributions, source: :contributable, 
    source_type: 'Download'
  has_many :links, through: :contributions, source: :contributable, 
    source_type: 'Link'
  has_many :music_tracks, through: :contributions, source: :contributable, 
    source_type: 'MusicTrack'
  has_many :pictures, through: :contributions, source: :contributable, 
    source_type: 'Picture'
  has_many :poems, through: :contributions, source: :contributable, 
    source_type: 'Poem'
  has_many :quizzes, through: :contributions, source: :contributable, 
    source_type: 'Quiz'
  has_many :resources, through: :contributions, source: :contributable, 
    source_type: 'Resource'
  has_many :stories, through: :contributions, source: :contributable, 
    source_type: 'Story'
  has_many :videos, through: :contributions, source: :contributable, 
    source_type: 'Video'

  validates :name, presence: true, length: { in: 2..50 }, uniqueness: true

  has_attached_file :avatar, styles: { thumbnail: "75x75#", embedded: "280x280>" },
    path: ":rails_root/public/system/:attachment/:id/:style/:avatar_filename",
    url: "/system/:attachment/:id/:style/:avatar_filename"

  validates_attachment :avatar,
    content_type: { content_type: "image/jpeg" },
    size: { in: 0..5.megabytes }

  before_post_process :avatar_filename

  # Sets avatar filename in the database.
  def avatar_filename
    if self.avatar_content_type == 'image/jpeg'
      self.avatar_file_name = "avatar.jpg" if self.avatar.present?
    end
  end

  # Sets avatar filename in the file system.
  Paperclip.interpolates :avatar_filename do |attachment, style|
    attachment.instance.avatar_filename
  end
end
