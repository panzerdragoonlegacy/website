FactoryGirl.define do
  factory :category_group do
    sequence(:name) { |n| "Category Group #{n}" }
    category_group_type :encyclopaedia_entry
  end
end
