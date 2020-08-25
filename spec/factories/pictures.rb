FactoryBot.define do
  factory :picture do
    factory :valid_picture do
      sequence(:name) { |n| "Picture #{n}" }
      description { 'Test Description' }
      picture do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/picture.jpg', 'image/jpeg'
        )
      end

      category { FactoryBot.create(:valid_picture_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_picture_in_published_category do
        publish { true }
        category { FactoryBot.create(:published_category) }
      end

      factory :unpublished_picture_in_published_category do
        publish { false }
        category { FactoryBot.create(:published_category) }
      end

      factory :published_picture_in_unpublished_category do
        publish { true }
        category { FactoryBot.create(:unpublished_category) }
      end

      factory :unpublished_picture_in_unpublished_category do
        publish { false }
        category { FactoryBot.create(:unpublished_category) }
      end
    end
  end
end
