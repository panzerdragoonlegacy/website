FactoryGirl.define do
  factory :story do
    factory :valid_story do
      sequence(:name) { |n| "Story #{n}" }
      description 'Test Description'

      category { FactoryGirl.create(:valid_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_story_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_story_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_story_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_story_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
