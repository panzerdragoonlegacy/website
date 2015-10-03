FactoryGirl.define do
  factory :quiz do
    factory :valid_quiz do
      sequence(:name) { |n| "Quiz #{n}" }
      description "Test Quiz"

      contributor_profiles { [FactoryGirl.create(:contributor_profile)] }

      factory :published_quiz do
        publish true
      end

      factory :unpublished_quiz do
        publish false
      end
    end
  end
end
