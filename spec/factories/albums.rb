FactoryGirl.define do
  factory :album do
    factory :valid_album do
      sequence(:name) { |n| "Album #{n}" }
      description 'Test Description'
      category { FactoryGirl.create(:valid_picture_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_album_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_album_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_album_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_album_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
