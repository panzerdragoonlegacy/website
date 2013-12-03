class Story < ActiveRecord::Base
  include Categorisable
  include Contributable
  include Illustratable
  include Relatable
  include Sluggable
  
  attr_accessible :category_id, :name, :description, :content, :publish, :dragoon_ids, :encyclopaedia_entry_ids,
    :illustrations_attributes  
  
  has_many :chapters, :dependent => :destroy
  
  validates :name, :presence => true, :length => { :in => 2..100 }, :uniqueness => true
  validates :description, :presence => true, :length => { :in => 2..250 }
  after_save :update_chapter_urls
  
  # Updates chapter urls based on the (potentially) changed story url.
  def update_chapter_urls
    self.chapters.each do |chapter|
      chapter.save
    end
  end
end