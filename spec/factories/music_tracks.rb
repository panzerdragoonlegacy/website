FactoryGirl.define do
  factory :music_track do
    factory :valid_music_track do
      sequence(:name) { |n| "Music Track #{n}" }
      description 'Test Description'
      mp3_music_track Rack::Test::UploadedFile.new(
        'spec/fixtures/music_track.mp3', 'audio/mp3'
      )

      category { FactoryGirl.create(:valid_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_music_track_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_music_track_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_music_track_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_music_track_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
