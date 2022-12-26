FactoryBot.define do
  factory :album do
    factory :valid_album do
      sequence(:name) { |n| "Album #{n}" }
      description { 'Test Description' }
      category { FactoryBot.create(:valid_picture_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_album do
        publish { true }
      end

      factory :unpublished_album do
        publish { false }
      end
    end
  end
end
