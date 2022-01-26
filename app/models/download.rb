class Download < ApplicationRecord
  include Categorisable
  include Contributable
  include Publishable
  include Taggable
  include SluggableWithId
  include Syncable

  has_paper_trail

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
  before_save :set_slug
  before_save :sync_file_names

  def sync_file_names
    sync_file_name_of :download, file_name: "#{slug_from_name}.zip"
    sync_file_name_of :download_picture, file_name: "#{slug_from_name}.jpg"
  end
end
