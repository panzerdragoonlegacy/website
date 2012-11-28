class MusicTrack < ActiveRecord::Base
  acts_as_url :name, :sync_url => true
  
  def to_param 
    url 
  end
  
  belongs_to :category
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations
  
  validates :track_number, :presence => true, :numericality => { :only_integer => true,
    :greater_than_or_equal_to => 0, :less_than_or_equal_to => 50 }
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  validates :category, :presence => true  
  
  validates_attachment_presence :mp3_music_track
  validates_attachment_presence :ogg_music_track
  validates_attachment_size :mp3_music_track, :less_than => 50.megabytes
  validates_attachment_size :ogg_music_track, :less_than => 50.megabytes
  validates_attachment_content_type :mp3_music_track, :content_type => ['audio/mp3']
  validates_attachment_content_type :ogg_music_track, :content_type => ['audio/ogg']

  has_attached_file :mp3_music_track,
    :path => ":rails_root/public/system/:attachment/:id/:style/:mp3_music_track_filename",
    :url => "/system/:attachment/:id/:style/:mp3_music_track_filename"
  has_attached_file :ogg_music_track,
    :path => ":rails_root/public/system/:attachment/:id/:style/:ogg_music_track_filename",
    :url => "/system/:attachment/:id/:style/:ogg_music_track_filename"
  
  before_post_process :mp3_music_track_filename, :ogg_music_track_filename
  
  # Sets mp3_music_track filename in the database.
  def mp3_music_track_filename
    if self.mp3_music_track_content_type == 'audio/mp3'
      self.mp3_music_track_file_name = self.name.to_url + ".mp3"
    end
  end
  
  # Sets ogg_music_track filename in the database.
  def ogg_music_track_filename
    if self.ogg_music_track_content_type == 'audio/ogg'
      self.ogg_music_track_file_name = self.name.to_url + ".ogg"
    end
  end
  
  # Sets mp3_music_track filename in the file system.
  Paperclip.interpolates :mp3_music_track_filename do |attachment, style|
    attachment.instance.mp3_music_track_filename
  end
  
  # Sets ogg_music_track filename in the file system.
  Paperclip.interpolates :ogg_music_track_filename do |attachment, style|
    attachment.instance.ogg_music_track_filename
  end
end