FactoryGirl.define do
  factory :share do
    factory :valid_share do
      sequence(:url) { |n| "https://#{n}" }
      comment 'Test comment'
      category { FactoryGirl.create(:valid_category) }
      contributor_profile { FactoryGirl.create(:valid_contributor_profile) }
    end
  end
end
