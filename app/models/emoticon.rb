class Emoticon < ActiveRecord::Base
  validates :name, :presence => true, :length => { :in => 2..25 }, :uniqueness => true
  validates :emoticon, :presence => true
  
  before_save :set_code
  
  def set_code
    self.code = ":" + self.name.to_url + ":"
  end
  
  validates_attachment_presence :emoticon
  validates_attachment_size :emoticon, :less_than => 1.megabyte
  validates_attachment_content_type :emoticon, :content_type => ['image/gif']

  has_attached_file :emoticon, :styles => { :original => "18x18" }, 
    :path => ":rails_root/public/system/:attachment/:id/:style/:emoticon_filename",
    :url => "/system/:attachment/:id/:style/:emoticon_filename"
  
  before_post_process :emoticon_filename
  
  # Sets emoticon filename in the database.
  def emoticon_filename
    if self.emoticon_content_type == 'image/gif'
      self.emoticon_file_name = self.name.to_url + ".gif"
    end
  end
  
  # Sets emoticon filename in the file system.
  Paperclip.interpolates :emoticon_filename do |attachment, style|
    attachment.instance.emoticon_filename
  end
end