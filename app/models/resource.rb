class Resource < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Illustratable
  include Relatable
  include Sluggable
    
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :content, presence: true
end
