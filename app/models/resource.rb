class Resource < ActiveRecord::Base
  acts_as_url :name, sync_url: true

  include Categorisable
  include Contributable
  include Publishable
  include Illustratable
  include Taggable

  validates :name, presence: true, length: { in: 2..100 }
  validates :content, presence: true

  before_save :set_published_at

  def to_param
    id.to_s + '-' + url
  end
end
