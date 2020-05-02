class Redirect < ActiveRecord::Base
  has_paper_trail

  validates :old_url, presence: true, length: { in: 2..250 }
  validates :new_url, presence: true, length: { in: 2..250 }
end
