class Download < ActiveRecord::Base
  include Categorisable  
  include Contributable
  include Relatable
  include Sluggable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file :download,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_attachment :download, presence: true,
    content_type: { content_type: "application/zip" },
    size: { in: 0..100.megabytes }
  
  before_save :sync_filename

  def sync_filename
    sync_filename_of :download, filename: "#{self.name.to_url}.zip"
  end
end
