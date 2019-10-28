class Article < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Illustratable
  include Publishable
  include Taggable
  include Sluggable

  validates :name, presence: true, uniqueness: true, length: { in: 2..100 }
  validates :description, presence: true, length: { in: 2..250 }
  validates :content, presence: true

  before_save :set_published_at
end
