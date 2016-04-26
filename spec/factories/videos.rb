FactoryGirl.define do
  factory :video do
    factory :valid_video do
      sequence(:name) { |n| "Video #{n}" }
      description 'Test Description'
      mp4_video Rack::Test::UploadedFile.new(
        'spec/fixtures/video.mp4', 'video/mp4')
      webm_video Rack::Test::UploadedFile.new(
        'spec/fixtures/video.webm', 'video/webm')

      category { FactoryGirl.create(:category) }
      contributor_profiles { [FactoryGirl.create(:contributor_profile)] }

      factory :published_video_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_video_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_video_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_video_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
