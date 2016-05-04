FactoryGirl.define do
  factory :picture do
    factory :valid_picture do
      sequence(:name) { |n| "Picture #{n}" }
      description 'Test Description'
      picture Rack::Test::UploadedFile.new(
        'spec/fixtures/picture.jpg', 'image/jpeg')

      category { FactoryGirl.create(:valid_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_picture_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_picture_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_picture_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_picture_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
