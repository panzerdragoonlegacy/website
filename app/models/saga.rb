class Saga < ActiveRecord::Base
  include SluggableWithoutId

  has_paper_trail

  belongs_to :page
  has_many :categories, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { in: 2..30 }
  validates(
    :sequence_number,
    presence: true,
    numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  )
end
