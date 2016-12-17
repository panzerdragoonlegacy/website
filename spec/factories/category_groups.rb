FactoryGirl.define do
  factory :category_group do
    factory :valid_category_group do
      sequence(:name) { |n| "Category Group #{n}" }
      category_group_type :encyclopaedia_entry

      factory :valid_picture_category_group do
        category_group_type :picture
      end
    end
  end
end
