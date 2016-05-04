FactoryGirl.define do
  factory :download do
    factory :valid_download do
      sequence(:name) { |n| "Download #{n}" }
      description 'Test Description'
      download Rack::Test::UploadedFile.new(
        'spec/fixtures/download.zip', 'application/zip')

      category { FactoryGirl.create(:valid_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_download_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_download_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_download_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_download_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
