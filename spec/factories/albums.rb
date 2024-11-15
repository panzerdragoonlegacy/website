FactoryBot.define do
  factory :album do
    factory :valid_album do
      sequence(:name) do
        n = ''
        loop do
          n = "Album #{rand(1000)}"
          break unless Album.where(name: n).exists?
        end
        n
      end
      description { 'Test Description' }
      category { FactoryBot.create(:valid_picture_category) }
      contributor_profiles { [FactoryBot.create(:valid_contributor_profile)] }

      factory :published_album do
        publish { true }
      end

      factory :unpublished_album do
        publish { false }
      end
    end
  end

  factory :album_attributes_except_publish do
    [
      :sequence_number,
      :source_url,
      :name,
      :description,
      :information,
      :category_id,
      :instagram_post_id,
      contributor_profile_ids: [],
      tag_ids: [],
      pictures_attributes: [
        :id,
        :category_id,
        :instagram_post_id,
        :picture,
        :_destroy,
        contributor_profile_ids: [],
        tag_ids: []
      ],
      videos_attributes: [
        :id,
        :category_id,
        :video_picture,
        :mp4_video,
        :_destroy,
        contributor_profile_ids: [],
        tag_ids: []
      ]
    ]
  end
end
