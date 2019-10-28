class Poem < ActiveRecord::Base
  include Contributable
  include Publishable
  include Taggable
  include Sluggable

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }
  validates :content, presence: true

  before_save :set_published_at
end
