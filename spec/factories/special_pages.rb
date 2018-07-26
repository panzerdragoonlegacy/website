FactoryGirl.define do
  factory :special_page do
    factory :valid_special_page do
      sequence(:name) { |n| "Special Page #{n}" }
      content 'Test Content'

      factory :published_special_page do
        publish true
      end

      factory :unpublished_special_page do
        publish false
      end
    end
  end
end
