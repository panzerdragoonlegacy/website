class EncyclopaediaEntry < ActiveRecord::Base
  include Categorisable
  include Illustratable
  include Sluggable
  include Syncable

  has_one :saga, dependent: :destroy
  has_many :contributions, as: :contributable, dependent: :destroy
  has_many :contributor_profiles, through: :contributions
  
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :information, presence: true
  validates :content, presence: true

  has_attached_file(
    :encyclopaedia_entry_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      embedded: '280x280>'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :encyclopaedia_entry_picture,
    presence: true,
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_save :sync_file_name

  def sync_file_name
    sync_file_name_of(
      :encyclopaedia_entry_picture,
      file_name: "#{name.to_url}.jpg"
    )
  end
end
