FactoryGirl.define do
  factory :chapter do
    factory :valid_chapter do
      sequence(:number) { |n| n }
      content 'Test Content'

      story { FactoryGirl.create(:valid_story) }
    end
  end
end
