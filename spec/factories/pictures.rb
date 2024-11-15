FactoryBot.define do
  factory :picture do
    factory :valid_picture do
      sequence(:name) do
        n = ''
        loop do
          n = "Picture #{rand(1000)}"
          break unless Picture.where(name: n).exists?
        end
        n
      end
      description { 'Test Description' }
      picture do
        Rack::Test::UploadedFile.new('spec/fixtures/picture.jpg', 'image/jpeg')
      end

      category { FactoryBot.create(:valid_picture_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_picture do
        publish { true }
      end

      factory :unpublished_picture do
        publish { false }
      end
    end
  end
end
