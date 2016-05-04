class Saga < ActiveRecord::Base
  include Sluggable

  belongs_to :encyclopaedia_entry
  validates :encyclopaedia_entry, presence: true

  validates :name, presence: true, uniqueness: true, length: { in: 2..30 }
  validates :sequence_number, presence: true, numericality: {
    only_integer: true, greater_than: 0, less_than: 100 }

  before_validation :validate_encyclopaedia_entry

  private

  def validate_encyclopaedia_entry
    encyclopaedia_entry_is_already_associated = false
    if self.encyclopaedia_entry
      if Saga.where(encyclopaedia_entry: self.encyclopaedia_entry).count > 0
        if self.persisted?
          persisted_saga = Saga.find(self.id)
          unless persisted_saga.encyclopaedia_entry == self.encyclopaedia_entry
            encyclopaedia_entry_is_already_associated = true
          end
        else
          encyclopaedia_entry_is_already_associated = true
        end
      end
      if encyclopaedia_entry_is_already_associated
        self.errors.add(encyclopaedia_entry.name, 'is already associated ' \
          'with another saga.')
      end
    end
  end
end
