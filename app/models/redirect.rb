class Redirect < ApplicationRecord
  has_paper_trail

  validates :old_url, presence: true, length: { in: 2..250 }
  validates :new_url, presence: true, length: { in: 2..250 }
end
