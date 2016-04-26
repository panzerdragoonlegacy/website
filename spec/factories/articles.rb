FactoryGirl.define do
  factory :article do
    factory :valid_article do
      sequence(:name) { |n| "Article #{n}" }
      description 'Test Description'
      content 'Test Content'

      category { FactoryGirl.create(:category) }
      contributor_profiles { [FactoryGirl.create(:contributor_profile)] }

      factory :published_article_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_article_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_article_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_article_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
