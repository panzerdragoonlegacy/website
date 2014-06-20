class Download < ActiveRecord::Base
  include Categorisable  
  include Contributable
  include Relatable
  include Sluggable
    
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file :download,
    path: ":rails_root/public/system/:attachment/:id/:style/:download_filename",
    url: "/system/:attachment/:id/:style/:download_filename"

  validates_attachment :download, presence: true,
    content_type: { content_type: "application/zip" },
    size: { in: 0..100.megabytes }
  
  before_post_process :download_filename
  
  # Sets download filename in the database.
  def download_filename
    if self.download_content_type == 'application/zip'
      self.download_file_name = self.name.to_url + ".zip"
    end
  end
  
  # Sets download filename in the file system.
  Paperclip.interpolates :download_filename do |attachment, style|
    attachment.instance.download_filename
  end
end
