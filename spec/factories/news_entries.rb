FactoryBot.define do
  factory :news_entry do
    factory :valid_news_entry do
      sequence(:name) do
        n = ''
        loop do
          n = "News Entry #{rand(1000)}"
          break unless NewsEntry.where(name: n).exists?
        end
        n
      end
      content { 'Test Content' }
      news_entry_picture do
        Rack::Test::UploadedFile.new(
          'spec/fixtures/news-entry-picture.jpg',
          'image/jpeg'
        )
      end

      contributor_profile { FactoryBot.create(:valid_contributor_profile) }

      factory :published_news_entry do
        publish { true }
      end

      factory :unpublished_news_entry do
        publish { false }
      end
    end
  end
end
