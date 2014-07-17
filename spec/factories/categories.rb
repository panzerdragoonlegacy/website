FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
    description "Test Description"

    factory :published_category do
      sequence(:name) { |n| "Published Category #{n}" }
      publish true
    end
  end
end
