class Quiz < ApplicationRecord
  include Contributable
  include Publishable
  include Taggable
  include SluggableWithoutId

  has_paper_trail

  has_many :quiz_questions, dependent: :destroy
  accepts_nested_attributes_for(
    :quiz_questions,
    reject_if: :all_blank,
    allow_destroy: true
  )

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }

  before_save :set_published_at
end
