class Video < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Relatable
  include Sluggable
    
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  
  validates_attachment_presence :mp4_video
  validates_attachment_presence :webm_video
  validates_attachment_size :mp4_video, :less_than => 50.megabytes
  validates_attachment_size :webm_video, :less_than => 50.megabytes
  validates_attachment_content_type :mp4_video, :content_type => ['video/mp4']
  validates_attachment_content_type :webm_video, :content_type => ['video/webm']

  has_attached_file :mp4_video,
    :path => ":rails_root/public/system/:attachment/:id/:style/:mp4_video_filename",
    :url => "/system/:attachment/:id/:style/:mp4_video_filename"
  has_attached_file :webm_video,
    :path => ":rails_root/public/system/:attachment/:id/:style/:webm_video_filename",
    :url => "/system/:attachment/:id/:style/:webm_video_filename"
  
  before_post_process :mp4_video_filename, :webm_video_filename
  
  # Sets mp4_video filename in the database.
  def mp4_video_filename
    if self.mp4_video_content_type == 'video/mp4'
      self.mp4_video_file_name = self.name.to_url + ".mp4"
    end
  end
  
  # Sets webm_video filename in the database.
  def webm_video_filename
    if self.webm_video_content_type == 'video/webm'
      self.webm_video_file_name = self.name.to_url + ".webm"
    end
  end
  
  # Sets mp4_video filename in the file system.
  Paperclip.interpolates :mp4_video_filename do |attachment, style|
    attachment.instance.mp4_video_filename
  end
  
  # Sets webm_video filename in the file system.
  Paperclip.interpolates :webm_video_filename do |attachment, style|
    attachment.instance.webm_video_filename
  end
end