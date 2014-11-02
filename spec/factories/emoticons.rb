FactoryGirl.define do
  factory :emoticon do
    factory :valid_emoticon do
      sequence(:name) { |n| "Emoticon #{n}" }
      emoticon Rack::Test::UploadedFile.new(
        'spec/fixtures/emoticon.gif', 'image/gif')
    end
  end
end
