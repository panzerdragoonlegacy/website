class Saga < ActiveRecord::Base
  include Sluggable

  belongs_to :encyclopaedia_entry
  validates :encyclopaedia_entry, presence: true, uniqueness: true

  validates :name, presence: true, uniqueness: true, length: { in: 2..25 }
  validates :sequence_number, presence: true, numericality: {
    only_integer: true, greater_than: 0, less_than: 100 }
end
