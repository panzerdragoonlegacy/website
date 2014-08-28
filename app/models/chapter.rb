class Chapter < ActiveRecord::Base
  include Illustratable
  
  acts_as_url :story_chapter_name, sync_url: true  
  
  def to_param
    url
  end
  
  belongs_to :story
  
  validates :number, presence: true, numericality: { only_integer: true,
    greater_than: 0, less_than: 100 }
  validates :content, presence: true
  
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
