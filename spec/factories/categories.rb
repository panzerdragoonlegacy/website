FactoryBot.define do
  factory :category do
    factory :valid_category do
      sequence(:name) { |n| "Category #{n}" }
      sequence(:short_name_for_saga) { |n| "Cat #{n}" }
      sequence(:short_name_for_media_type) { |n| "Cat #{n}" }
      description { 'Test Description' }
      category_type { :literature }
      category_group { FactoryBot.create(:valid_category_group) }

      factory :valid_literature_category do
        category_type { :literature }
        category_group { FactoryBot.create(:valid_literature_category_group) }
      end

      factory :valid_picture_category do
        category_type { :picture }
        category_group { FactoryBot.create(:valid_picture_category_group) }

        factory :published_picture_category do
          publish { true }

          factory :published_picture_category_in_saga do
            saga { FactoryBot.create(:valid_saga) }
          end
        end

        factory :unpublished_picture_category do
          publish { false }
        end
      end

      factory :valid_video_category do
        category_type { :video }
        category_group { FactoryBot.create(:valid_video_category_group) }
      end

      factory :published_category do
        publish { true }

        factory :published_category_in_saga do
          saga { FactoryBot.create(:valid_saga) }
        end
      end

      factory :unpublished_category do
        publish { false }
      end
    end
  end
end
