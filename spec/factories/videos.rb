FactoryBot.define do
  factory :video do
    factory :valid_video do
      sequence(:name) { |n| "Video #{n}" }
      description { 'Test Description' }
      mp4_video do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/video.mp4', 'video/mp4'
        )
      end

      category { FactoryBot.create(:valid_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_video_in_published_category do
        publish { true }
        category { FactoryBot.create(:published_category) }
      end

      factory :unpublished_video_in_published_category do
        publish { false }
        category { FactoryBot.create(:published_category) }
      end

      factory :published_video_in_unpublished_category do
        publish { true }
        category { FactoryBot.create(:unpublished_category) }
      end

      factory :unpublished_video_in_unpublished_category do
        publish { false }
        category { FactoryBot.create(:unpublished_category) }
      end
    end
  end
end
