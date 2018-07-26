class Link < ActiveRecord::Base
  include Categorisable
  include Taggable

  has_many :contributions, as: :contributable, dependent: :destroy
  has_many :contributor_profiles, through: :contributions

  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :url, presence: true, length: { in: 2..250 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }
end
