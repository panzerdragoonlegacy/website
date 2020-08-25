FactoryBot.define do
  factory :tag do
    factory :valid_tag do
      sequence(:name) { |n| "Tag #{n}" }
    end
  end
end
