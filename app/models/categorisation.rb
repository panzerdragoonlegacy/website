class Categorisation < ApplicationRecord
  belongs_to :parent,
             class_name: 'Category',
             foreign_key: 'parent_id',
             inverse_of: :categorisations
  belongs_to :subcategory,
             class_name: 'Category',
             foreign_key: 'subcategory_id',
             inverse_of: :categorisation

  validates(
    :sequence_number,
    presence: true,
    numericality: {
      only_integer: true,
      greater_than_or_equal_to: 1,
      less_than_or_equal_to: 99
    }
  )
  validates :subcategory_id, presence: true
  validates :short_name_in_parent, presence: true, length: { in: 1..50 }
end
