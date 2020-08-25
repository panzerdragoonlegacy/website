FactoryBot.define do
  factory :saga do
    factory :valid_saga do
      sequence(:name) { |n| "Saga #{n}" }
      sequence(:sequence_number) { |n| n }

      page { FactoryBot.create(:valid_encyclopaedia_page) }
    end
  end
end
