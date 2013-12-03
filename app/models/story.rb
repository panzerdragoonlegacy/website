class Story < ActiveRecord::Base
  include Sluggable
  include Categorisable
  
  attr_accessible :category_id, :name, :description, :content, :publish, :dragoon_ids, :encyclopaedia_entry_ids,
    :illustrations_attributes  
  
  has_many :contributions, :as => :contributable, :dependent => :destroy
  has_many :dragoons, :through => :contributions
  has_many :relations, :as => :relatable, :dependent => :destroy
  has_many :encyclopaedia_entries, :through => :relations
  has_many :chapters, :dependent => :destroy
  has_many :illustrations, :as => :illustratable, :dependent => :destroy
  accepts_nested_attributes_for :illustrations, :reject_if => lambda { |a| a[:illustration].blank? }, 
    :allow_destroy => true
  
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