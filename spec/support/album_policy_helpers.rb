def album_attributes_except_publish
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
