class Redirect < ApplicationRecord
  has_paper_trail

  validates :old_url, presence: true, length: { in: 2..250 }
  validates :new_url, presence: true, length: { in: 2..250 }

  def self.ransackable_attributes(auth_object = nil)
    %w[old_url new_url comment created_at updated_at]
  end
end
