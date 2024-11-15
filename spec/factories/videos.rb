FactoryBot.define do
  factory :video do
    factory :valid_video do
      sequence(:name) do
        n = ''
        loop do
          n = "Video #{rand(1000)}"
          break unless Video.where(name: n).exists?
        end
        n
      end
      description { 'Test Description' }
      mp4_video do
        Rack::Test::UploadedFile.new('spec/fixtures/video.mp4', 'video/mp4')
      end

      category { FactoryBot.create(:valid_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_video do
        publish { true }
      end

      factory :unpublished_video do
        publish { false }
      end
    end
  end
end
