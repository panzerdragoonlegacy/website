FactoryGirl.define do
  factory :page do
    factory :valid_page do
      sequence(:name) { |n| "Page #{n}" }
      content 'Test Content'
    end
  end
end
