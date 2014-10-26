class EncyclopaediaEntry < ActiveRecord::Base
  include Categorisable
  include Illustratable
  include Sluggable
  
  has_many :relations, dependent: :destroy
  has_many :articles, through: :relations, source: :relatable, source_type: 'Article'
  has_many :downloads, through: :relations, source: :relatable, source_type: 'Download'
  has_many :links, through: :relations, source: :relatable, source_type: 'Link'
  has_many :music_tracks, through: :relations, source: :relatable, source_type: 'MusicTrack'
  has_many :pictures, through: :relations, source: :relatable, source_type: 'Picture'
  has_many :poems, through: :relations, source: :relatable, source_type: 'Poem'
  has_many :quizzes, through: :relations, source: :relatable, source_type: 'Quiz'
  has_many :resources, through: :relations, source: :relatable, source_type: 'Resource'
  has_many :stories, through: :relations, source: :relatable, source_type: 'Story'
  has_many :videos, through: :relations, source: :relatable, source_type: 'Video'
  
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :information, presence: true  
  validates :content, presence: true

  has_attached_file :encyclopaedia_entry_picture, styles: { thumbnail: "150x150", embedded: "280x280>" }, 
    path: ":rails_root/public/system/:attachment/:id/:style/:encyclopaedia_entry_picture_filename",
    url: "/system/:attachment/:id/:style/:encyclopaedia_entry_picture_filename"

  validates_attachment :encyclopaedia_entry_picture, presence: true,
    content_type: { content_type: "image/jpeg" },
    size: { in: 0..5.megabytes }
  
  before_post_process :encyclopaedia_entry_picture_filename
  
  # Sets encyclopaedia_entry_picture filename in the database.
  def encyclopaedia_entry_picture_filename
    if self.encyclopaedia_entry_picture_content_type == 'image/jpeg'
      self.encyclopaedia_entry_picture_file_name = self.name.to_url + ".jpg" if self.encyclopaedia_entry_picture.present?
    end
  end
  
  # Sets encyclopaedia_entry_picture filename in the file system.
  Paperclip.interpolates :encyclopaedia_entry_picture_filename do |attachment, style|
    attachment.instance.encyclopaedia_entry_picture_filename
  end
end
