class SpecialPage < ActiveRecord::Base
  include Publishable
  include Sluggable
  include Illustratable

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :content, presence: true

  before_save :set_published_at
end
