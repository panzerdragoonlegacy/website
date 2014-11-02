class Illustration < ActiveRecord::Base
  include Syncable

  belongs_to :illustratable, polymorphic: true
  
  has_attached_file :illustration, 
    styles: { 
      embedded: "280x280>", 
      popover: "625x625" 
    }, 
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"
  
  validates_attachment :illustration, presence: true,
    content_type: { content_type: "image/jpeg" },
    size: { in: 0..5.megabytes }

  before_save :sync_filename

  def sync_filename
    sync_filename_of :illustration, 
      filename: "#{self.illustration_file_name.split('.')[0].to_url}.jpg"
  end
end
