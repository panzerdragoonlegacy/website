class Share < ActiveRecord::Base
  include Categorisable
  include Taggable

  belongs_to :contributor_profile

  validates :url, presence: true, length: { in: 1..250 }, uniqueness: true
  validates :comment, length: { in: 0..250 }
  validates :category, presence: true
  validates :contributor_profile, presence: true
end
