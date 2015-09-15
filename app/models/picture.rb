class Picture < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Relatable
  include Sluggable
  include Syncable
  
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file :picture, 
    styles: { 
      mini_thumbnail: "75x75#", 
      thumbnail: "150x150>", 
      triple_thumbnail: "150x150#",
      double_thumbnail: "240x240#", 
      single_thumbnail: "486x486>", 
      embedded: "625x625>" 
    }, 
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_attachment :picture, presence: true,
    content_type: { content_type: "image/jpeg" },
    size: { in: 0..5.megabytes }

  #before_save :sync_file_name

  def sync_file_name
    sync_file_name_of :picture, file_name: "#{self.name.to_url}.jpg"
  end
end
