FactoryGirl.define do
  factory :dragoon do
    sequence(:name) { |n| "User #{n}" }
  end
end
