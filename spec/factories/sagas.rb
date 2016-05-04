FactoryGirl.define do
  factory :saga do
    factory :valid_saga do
      sequence(:name) { |n| "Saga #{n}" }
      sequence(:sequence_number) { |n| n }

      encyclopaedia_entry { FactoryGirl.create(:valid_encyclopaedia_entry) }
    end
  end
end
