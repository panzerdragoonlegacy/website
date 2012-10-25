class Chapter < ActiveRecord::Base
  acts_as_url :story_chapter_name, :sync_url => true  
  
  def to_param
    url
  end
  
  attr_accessible :story_id, :chapter_type, :number, :name, :content, :publish, 
    :illustrations_attributes
  
  belongs_to :story
  has_many :illustrations, :as => :illustratable, :dependent => :destroy
  accepts_nested_attributes_for :illustrations, :reject_if => lambda { |a| a[:illustration].blank? }, 
    :allow_destroy => true
  
  validates :number, :presence => true
  validates :content, :presence => true
  
  # The list of chapter types.
  CHAPTER_TYPES = %w[prologue regular_chapter epilogue]
  
  def story_chapter_name
    if self.chapter_type == :regular_chapter.to_s
      if self.name.blank?
        return self.story.name + "-" + self.number.to_s
      else
        return self.story.name + "-" + self.number.to_s + "-" + self.name
      end
    else
      return self.story.name + "-" + self.name
    end
  end
end
