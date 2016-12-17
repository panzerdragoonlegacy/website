class Saga < ActiveRecord::Base
  include Sluggable

  belongs_to :encyclopaedia_entry
  validates :encyclopaedia_entry, presence: true

  validates :name, presence: true, uniqueness: true, length: { in: 2..30 }
  validates(
    :sequence_number,
    presence: true,
    numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  )

  before_validation :validate_encyclopaedia_entry

  private

  def validate_encyclopaedia_entry
    if encyclopaedia_entry && encyclopaedia_entry_already_associated
      errors.add(encyclopaedia_entry.name, 'is already associated with ' \
        'another saga.')
    end
  end

  def encyclopaedia_entry_already_associated
    if Saga.where(encyclopaedia_entry: encyclopaedia_entry).count > 0
      return true unless persisted?
      true if Saga.find(id).encyclopaedia_entry != encyclopaedia_entry
    end
  end
end
