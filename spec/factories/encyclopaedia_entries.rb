FactoryGirl.define do
  factory :encyclopaedia_entry do
    factory :valid_encyclopaedia_entry do
      sequence(:name) { |n| "Encyclopaedia Entry #{n}" }
      information "Test Information"
      content "Test Content"
      encyclopaedia_entry_picture Rack::Test::UploadedFile.new(
        'spec/fixtures/encyclopaedia-entry-picture.jpg', 'image/jpeg')

      category { FactoryGirl.create(:category) }
    end
  end
end
