class QuizQuestion < ActiveRecord::Base
  belongs_to :quiz
  has_many :quiz_answers, dependent: :destroy
  accepts_nested_attributes_for :quiz_answers, reject_if: :all_blank, allow_destroy: true
end
