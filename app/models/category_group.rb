class CategoryGroup < ApplicationRecord
  include SluggableWithoutId

  has_paper_trail

  has_many :categories, dependent: :destroy

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true

  # The list of category group types.
  CATEGORY_GROUP_TYPES = %w(
    encyclopaedia
    literature
    picture
    music_track
    video
    download
  ).freeze
end
