FactoryGirl.define do
  factory :download do
    factory :valid_download do
      sequence(:name) { |n| "Download #{n}" }
      description "Test Description"
      download Rack::Test::UploadedFile.new(
        'spec/fixtures/download.zip', 'application/zip')

      category { FactoryGirl.create(:category) }
      dragoons { [FactoryGirl.create(:dragoon)] }
    end
  end
end
