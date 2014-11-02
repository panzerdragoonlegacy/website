FactoryGirl.define do
  factory :picture do
    factory :valid_picture do
      sequence(:name) { |n| "Picture #{n}" }
      description "Test Description"
      picture Rack::Test::UploadedFile.new(
        'spec/fixtures/picture.jpg', 'image/jpeg')

      category { FactoryGirl.create(:category) }
      dragoons { [FactoryGirl.create(:dragoon)] }
    end
  end
end
