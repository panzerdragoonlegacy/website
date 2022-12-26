FactoryBot.define do
  factory :page do
    factory :valid_page do
      sequence(:name) { |n| "Page #{n}" }
      page_type { :top_level.to_s }
      content { 'Test Content' }
      page_picture do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/page-picture.jpg',
          'image/jpeg'
        )
      end

      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :valid_literature_page do
        page_type { :literature.to_s }
        description { 'Test Description' }
        category { FactoryBot.create(:valid_literature_category) }

        factory :published_page do
          publish { true }
        end

        factory :unpublished_page do
          publish { false }
        end
      end
    end
  end
end
