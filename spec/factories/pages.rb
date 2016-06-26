FactoryGirl.define do
  factory :page do
    factory :valid_page do
      sequence(:name) { |n| "Page #{n}" }
      content 'Test Content'

      factory :published_page do
        publish true
      end

      factory :unpublished_page do
        publish false
      end
    end
  end
end
