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

  before_validation :validate_presence_of_name

  private

  def validate_presence_of_name
    if self.chapter_type != :regular_chapter.to_s && self.name.blank?
      self.errors.add(name, 'must be present for prologues and epilogues.')
    end
  end

  def story_chapter_name
    # A chapter should always belong to a story; this check is here so that the
    # validation Shoulda Matchers can pass without presence of a story.
    if self.story
      if self.chapter_type == :regular_chapter.to_s
        return self.story.name + "-" + self.number.to_s if self.name.blank?
        return self.story.name + "-" + self.number.to_s + "-" + self.name
      end
      return self.story.name + "-" + self.name
    end
  end
end
