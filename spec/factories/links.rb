FactoryGirl.define do
  factory :link do
    factory :valid_link do
      sequence(:name) { |n| "Link #{n}" }
      sequence(:url) { |n| "http://www.example#{n}.com" }
      description 'Test Description'

      category { FactoryGirl.create(:category) }

      factory :link_in_published_category do
        category { FactoryGirl.create(:published_category) }
      end

      factory :link_in_unpublished_category do
        category { FactoryGirl.create(:unpublished_category) }
      end
    end
  end
end
