FactoryBot.define do
  factory :saga do
    factory :valid_saga do
      sequence(:name) { |n| "Saga #{n}" }
      sequence(:sequence_number) { |n| n }

      tag { FactoryBot.create(:valid_tag) }
    end
  end
end
