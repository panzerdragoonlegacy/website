FactoryBot.define do
  factory :download do
    factory :valid_download do
      sequence(:name) { |n| "Download #{n}" }
      description { 'Test Description' }
      download do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/download.zip', 'application/zip'
        )
      end

      category { FactoryBot.create(:valid_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_download_in_published_category do
        publish { true }
        category { FactoryBot.create(:published_category) }
      end

      factory :unpublished_download_in_published_category do
        publish { false }
        category { FactoryBot.create(:published_category) }
      end

      factory :published_download_in_unpublished_category do
        publish { true }
        category { FactoryBot.create(:unpublished_category) }
      end

      factory :unpublished_download_in_unpublished_category do
        publish { false }
        category { FactoryBot.create(:unpublished_category) }
      end
    end
  end
end
