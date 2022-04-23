class Illustration < ApplicationRecord
  include Sluggable
  include Syncable

  belongs_to :page

  has_attached_file(
    :illustration,
    styles: {
      embedded: '280x280>',
      small: '450x450>',
      medium2: '700x700>',
      popover: '625x625'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :illustration,
    presence: true,
    content_type: {
      content_type: 'image/jpeg'
    },
    size: {
      in: 0..5.megabytes
    }
  )

  before_save :sync_file_name

  def sync_file_name
    sync_file_name_of(
      :illustration,
      file_name: "#{generate_slug(illustration_file_name.split('.')[0])}.jpg"
    )
  end
end
