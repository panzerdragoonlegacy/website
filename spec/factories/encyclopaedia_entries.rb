FactoryGirl.define do
  factory :encyclopaedia_entry do
    factory :valid_encyclopaedia_entry do
      sequence(:name) { |n| "Encyclopaedia Entry #{n}" }
      information 'Test Information'
      content 'Test Content'
      encyclopaedia_entry_picture Rack::Test::UploadedFile.new(
        'spec/fixtures/encyclopaedia-entry-picture.jpg', 'image/jpeg')

      category { FactoryGirl.create(:valid_category) }
      contributor_profiles { [FactoryGirl.create(:valid_contributor_profile)] }

      factory :published_encyclopaedia_entry_in_published_category do
        publish true
        category { FactoryGirl.create(:published_category) }
      end

      factory :unpublished_encyclopaedia_entry_in_published_category do
        publish false
        category { FactoryGirl.create(:published_category) }
      end

      factory :published_encyclopaedia_entry_in_unpublished_category do
        publish true
        category { FactoryGirl.create(:unpublished_category) }
      end

      factory :unpublished_encyclopaedia_entry_in_unpublished_category do
        publish false
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
