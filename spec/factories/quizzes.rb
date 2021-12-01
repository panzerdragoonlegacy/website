FactoryBot.define do
  factory :quiz do
    factory :valid_quiz do
      sequence(:name) { |n| "Quiz #{n}" }
      description { 'Test Description' }

      category { FactoryBot.create(:valid_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_quiz do
        publish { true }
      end

      factory :unpublished_quiz do
        publish { false }
      end
    end
  end
end
