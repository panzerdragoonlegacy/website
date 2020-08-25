FactoryBot.define do
  factory :contributor_profile do
    factory :valid_contributor_profile do
      sequence(:name) { |n| "Contributor #{n}" }

      factory :published_contributor_profile do
        publish { true }
      end

      factory :unpublished_contributor_profile do
        publish { false }
      end
    end
  end
end
