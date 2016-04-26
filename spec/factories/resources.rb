FactoryGirl.define do
  factory :resource do
    factory :valid_resource do
      sequence(:name) { |n| "Resource #{n}" }
      content 'Test Content'

      category { FactoryGirl.create(:category) }
      contributor_profiles { [FactoryGirl.create(:contributor_profile)] }

      factory :published_resource_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_resource_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_resource_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_resource_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
