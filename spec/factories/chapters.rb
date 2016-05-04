FactoryGirl.define do
  factory :chapter do
    factory :valid_chapter do
      sequence(:number) { |n| n }
      content 'Test Content'

      story { FactoryGirl.create(:valid_story) }

      factory :regular_chapter do
        chapter_type :regular_chapter
      end

      factory :prologue do
        chapter_type :prologue
      end
    end
  end
end
