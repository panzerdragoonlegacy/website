FactoryGirl.define do
  factory :contributor_profile do
    sequence(:name) { |n| "Contributor #{n}" }
  end
end
