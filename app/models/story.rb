class Story < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Illustratable
  include Relatable
  include Sluggable
    
  has_many :chapters, dependent: :destroy
  
  validates :name, presence: true, length: { in: 2..100 }, uniqueness: true
  validates :description, presence: true, length: { in: 2..250 }
  
  after_save :update_chapter_urls

  # Updates chapter urls based on the (potentially) changed story url.
  def update_chapter_urls
    self.chapters.each do |chapter|
      chapter.save
    end
  end
end