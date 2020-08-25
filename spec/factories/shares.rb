FactoryBot.define do
  factory :share do
    factory :valid_share do
      sequence(:url) { |n| "https://#{n}" }
      comment { 'Test comment' }
      category { FactoryBot.create(:valid_category) }
      contributor_profile { FactoryBot.create(:valid_contributor_profile) }
    end
  end
end
