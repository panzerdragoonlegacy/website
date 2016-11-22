class Download < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Relatable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file :download,
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_attachment :download, presence: true,
    content_type: { content_type: "application/zip" },
    size: { in: 0..100.megabytes }

  before_save :sync_file_name

  def sync_file_name
    sync_file_name_of :download, file_name: "#{self.name.to_url}.zip"
  end

  def to_param
    id.to_s + '-' + url 
  end
end
