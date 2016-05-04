FactoryGirl.define do
  factory :category do
    factory :valid_category do
      sequence(:name) { |n| "Category #{n}" }
      description 'Test Description'
      category_type :article

      factory :published_category do
        publish true
      end

      factory :unpublished_category do
        publish false
      end
    end
  end
end
