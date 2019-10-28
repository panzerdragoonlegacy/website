class Download < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Publishable
  include Taggable
  include Syncable

  validates :name, presence: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }

  has_attached_file(
    :download,
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )
  has_attached_file(
    :download_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      embedded: '280x280>'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :download,
    presence: true,
    content_type: { content_type: 'application/zip' },
    size: { in: 0..500.megabytes }
  )
  validates_attachment(
    :download_picture,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_save :set_published_at
  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :download, file_name: "#{name.to_url}.zip"
    sync_file_name_of :download_picture, file_name: "#{name.to_url}.jpg"
  end

  def to_param
    id.to_s + '-' + url
  end
end
