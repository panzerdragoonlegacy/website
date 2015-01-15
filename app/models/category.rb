class Category < ActiveRecord::Base
  include Sluggable

  has_many :articles, dependent: :destroy
  has_many :downloads, dependent: :destroy
  has_many :encyclopaedia_entries, dependent: :destroy
  has_many :links, dependent: :destroy
  has_many :music_tracks, dependent: :destroy
  has_many :pictures, dependent: :destroy
  has_many :resources, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :videos, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  # The list of category types.
  CATEGORY_TYPES = %w[article download encyclopaedia_entry link music_track
    picture resource story video]
end
