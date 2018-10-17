class Tag < ActiveRecord::Base
  include Sluggable

  has_many :taggings, dependent: :destroy

  has_many(
    :news_entries,
    through: :taggings,
    source: :taggable,
    source_type: 'NewsEntry'
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
end
