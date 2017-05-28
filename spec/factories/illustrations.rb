FactoryGirl.define do
  factory :illustration do
    factory :valid_illustration do
      illustration Rack::Test::UploadedFile.new(
        'spec/fixtures/illustration.jpg', 'image/jpeg'
      )
    end
  end
end
