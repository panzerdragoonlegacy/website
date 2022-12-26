FactoryBot.define do
  factory :music_track do
    factory :valid_music_track do
      sequence(:name) { |n| "Music Track #{n}" }
      description { 'Test Description' }
      mp3_music_track do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/music_track.mp3',
          'audio/mp3'
        )
      end

      category { FactoryBot.create(:valid_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_music_track do
        publish { true }
      end

      factory :unpublished_music_track do
        publish { false }
      end
    end
  end
end
