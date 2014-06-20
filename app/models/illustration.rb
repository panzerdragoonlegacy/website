class Illustration < ActiveRecord::Base
  belongs_to :illustratable, polymorphic: true
  
  has_attached_file :illustration, styles: { embedded: "280x280>", popover: "625x625" }, 
    path: ":rails_root/public/system/:attachment/:id/:style/:illustration_filename",
    url: "/system/:attachment/:id/:style/:illustration_filename"
  
  validates_attachment :illustration, presence: true,
    content_type: { content_type: "image/jpeg" },
    size: { in: 0..5.megabytes }
  
  before_post_process :illustration_filename
  
  # Sets illustration filename in the database.
  def illustration_filename
    if self.illustration_content_type == 'image/jpeg'
      self.illustration_file_name = self.illustration_file_name.split('.')[0].to_url + ".jpg"
    end
  end
  
  # Sets illustration filename in the file system.
  Paperclip.interpolates :illustration_filename do |attachment, style|
    attachment.instance.illustration_filename
  end
end
