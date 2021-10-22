class Categorisation < ApplicationRecord
  belongs_to :parent, class_name: 'Category', foreign_key: 'parent_id'
  has_one :subcategory, class_name: 'Category', foreign_key: 'id'

  validates(
    :sequence_number,
    presence: true,
    numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  )
  validates :subcategory_id, presence: true
  validates :short_name_in_parent, presence: true, length: { in: 1..50 }
end
