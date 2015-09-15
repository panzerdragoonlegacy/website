class Emoticon < ActiveRecord::Base
  include Syncable

  validates :name, presence: true, length: { in: 2..25 }, uniqueness: true

  has_attached_file :emoticon, styles: { original: "18x18" }, 
    path: ":rails_root/public/system/:attachment/:id/:style/:filename",
    url: "/system/:attachment/:id/:style/:filename"

  validates_attachment :emoticon, presence: true,
    content_type: { content_type: "image/gif" },
    size: { in: 0..1.megabytes }
  
  #before_save :sync_file_name, :set_code

  def sync_file_name
    sync_file_name_of :emoticon, file_name: "#{self.name.to_url}.gif"
  end

  def set_code
    self.code = ":#{self.name.to_url}:"
  end
end
