class Tag < ApplicationRecord
  include SluggableWithoutId
  include Syncable

  has_paper_trail

  has_many :taggings, dependent: :destroy

  has_many(
    :news_entries,
    through: :taggings,
    source: :taggable,
    source_type: 'NewsEntry'
  )
  has_many(:pages, through: :taggings, source: :taggable, source_type: 'Page')
  has_many(
    :pictures,
    through: :taggings,
    source: :taggable,
    source_type: 'Picture'
  )
  has_many(
    :music_tracks,
    through: :taggings,
    source: :taggable,
    source_type: 'MusicTrack'
  )
  has_many(:videos, through: :taggings, source: :taggable, source_type: 'Video')
  has_many(
    :downloads,
    through: :taggings,
    source: :taggable,
    source_type: 'Download'
  )

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true

  has_attached_file(
    :tag_picture,
    styles: {
      mini_thumbnail: '25x25#',
      thumbnail: '150x150',
      embedded: '622x250#'
    },
    path: ':rails_root/public/system/:attachment/:id/:style/:filename',
    url: '/system/:attachment/:id/:style/:filename'
  )

  validates_attachment(
    :tag_picture,
    content_type: {
      content_type: 'image/jpeg'
    },
    size: {
      in: 0..5.megabytes
    }
  )

  before_save :set_slug
  before_save :sync_file_name

  def sync_file_name
    if name.present?
      sync_file_name_of :tag_picture, file_name: "#{slug_from_name}.jpg"
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at updated_at]
  end
end
