class Saga < ApplicationRecord
  include SluggableWithoutId

  has_paper_trail

  belongs_to :tag
  has_many :categories, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 2..30 }
  validates(
    :sequence_number,
    presence: true,
    numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  )

  before_save :set_slug
end
