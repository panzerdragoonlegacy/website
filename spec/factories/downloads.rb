FactoryBot.define do
  factory :download do
    factory :valid_download do
      sequence(:name) { |n| "Download #{n}" }
      description { 'Test Description' }
      download do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/download.zip',
          'application/zip'
        )
      end

      category { FactoryBot.create(:valid_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_download do
        publish { true }
      end

      factory :unpublished_download do
        publish { false }
      end
    end
  end
end
