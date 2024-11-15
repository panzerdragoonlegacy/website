FactoryBot.define do
  factory :category do
    factory :valid_category do
      sequence(:name) do
        n = ''
        loop do
          n = "Category #{rand(1000)}"
          break unless Category.where(name: n).exists?
        end
        n
      end
      description { 'Test Description' }
      category_type { :literature }

      factory :valid_parent_category do
        category_type { :parent }
      end

      factory :valid_literature_category do
        category_type { :literature }
      end

      factory :valid_picture_category do
        category_type { :picture }

        factory :published_picture_category do
          publish { true }
        end

        factory :unpublished_picture_category do
          publish { false }
        end
      end

      factory :valid_video_category do
        category_type { :video }
      end

      factory :published_category do
        publish { true }
      end

      factory :unpublished_category do
        publish { false }
      end
    end
  end
end
