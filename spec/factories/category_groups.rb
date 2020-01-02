FactoryGirl.define do
  factory :category_group do
    factory :valid_category_group do
      sequence(:name) { |n| "Category Group #{n}" }
      category_group_type :literature

      factory :valid_encyclopaedia_category_group do
        category_group_type :encyclopaedia
      end

      factory :valid_literature_category_group do
        category_group_type :literature
      end

      factory :valid_picture_category_group do
        category_group_type :picture
      end

      factory :valid_video_category_group do
        category_group_type :video
      end
    end
  end
end
