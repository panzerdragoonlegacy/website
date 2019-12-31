class Link < ActiveRecord::Base
  belongs_to :category
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :url, presence: true, length: { in: 2..250 }, uniqueness: true
end
