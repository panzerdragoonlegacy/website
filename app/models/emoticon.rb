class Emoticon < ActiveRecord::Base
  validates :name, presence: true, length: { in: 2..25 }, uniqueness: true
  
  before_save :set_code

  has_attached_file :emoticon, styles: { original: "18x18" }, 
    path: ":rails_root/public/system/:attachment/:id/:style/:emoticon_filename",
    url: "/system/:attachment/:id/:style/:emoticon_filename"

  validates_attachment :emoticon, presence: true,
    content_type: { content_type: "image/gif" },
    size: { in: 0..1.megabytes }
  
  before_post_process :emoticon_filename
  
  # Sets emoticon filename in the database.
  def emoticon_filename
    if self.emoticon_content_type == 'image/gif'
      self.emoticon_file_name = self.name.to_url + ".gif" if self.emoticon.present?
    end
  end
  
  # Sets emoticon filename in the file system.
  Paperclip.interpolates :emoticon_filename do |attachment, style|
    attachment.instance.emoticon_filename
  end

  private

  def set_code
    self.code = ":" + self.name.to_url + ":"
  end
end
