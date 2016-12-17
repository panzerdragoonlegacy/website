FactoryGirl.define do
  factory :album do
    factory :valid_album do
      sequence(:name) { |n| "Album #{n}" }
      description 'Test Description'
      category { FactoryGirl.create(:valid_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }
    end
  end
end
