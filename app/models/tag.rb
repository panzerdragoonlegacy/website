class Tag < ActiveRecord::Base
  include Sluggable
  include Syncable

  has_many :taggings, dependent: :destroy

  has_many(
    :news_entries,
    through: :taggings,
    source: :taggable,
    source_type: 'NewsEntry'
  )
  has_many(
    :pages,
    through: :taggings,
    source: :taggable,
    source_type: 'Page'
  )
  has_many(
    :articles,
    through: :taggings,
    source: :taggable,
    source_type: 'Article'
  )
  has_many(
    :downloads,
    through: :taggings,
    source: :taggable,
    source_type: 'Download'
  )
  has_many(
    :links,
    through: :taggings,
    source: :taggable,
    source_type: 'Link'
  )
  has_many(
    :music_tracks,
    through: :taggings,
    source: :taggable,
    source_type: 'MusicTrack'
  )
  has_many(
    :pictures,
    through: :taggings,
    source: :taggable,
    source_type: 'Picture'
  )
  has_many(
    :poems,
    through: :taggings,
    source: :taggable,
    source_type: 'Poem'
  )
  has_many(
    :quizzes,
    through: :taggings,
    source: :taggable,
    source_type: 'Quiz'
  )
  has_many(
    :resources,
    through: :taggings,
    source: :taggable,
    source_type: 'Resource'
  )
  has_many(
    :stories,
    through: :taggings,
    source: :taggable,
    source_type: 'Story'
  )
  has_many(
    :videos,
    through: :taggings,
    source: :taggable,
    source_type: 'Video'
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
    content_type: { content_type: 'image/jpeg' },
    size: { in: 0..5.megabytes }
  )

  before_save :sync_file_name

  def sync_file_name
    sync_file_name_of :tag_picture, file_name: "#{name.to_url}.jpg"
  end
end
