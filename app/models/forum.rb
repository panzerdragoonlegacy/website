class Forum < ActiveRecord::Base
  include Sluggable

  has_many :discussions, :dependent => :destroy  
  has_many :comments, :through => :discussions, :dependent => :destroy
  

    
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  
  validates_attachment_size :forum_picture, :less_than => 5.megabytes
  validates_attachment_content_type :forum_picture, :content_type => ['image/jpeg']

  has_attached_file :forum_picture, :styles => { :thumbnail => "150x150" }, 
    :path => ":rails_root/public/system/:attachment/:id/:style/:forum_picture_filename",
    :url => "/system/:attachment/:id/:style/:forum_picture_filename"
  
  before_post_process :forum_picture_filename
  
  # Sets forum picture filename in the database.
  def forum_picture_filename
    if self.forum_picture_content_type == 'image/jpeg'
      self.forum_picture_file_name = "forum-picture.jpg"
    end
  end
  
  # Sets forum picture filename in the file system.
  Paperclip.interpolates :forum_picture_filename do |attachment, style|
    attachment.instance.forum_picture_filename
  end
end