module TagsHelper
  def tagged_count(tag)
    news_entry_count(tag) + literature_count(tag) + picture_count(tag) +
      music_track_count(tag) + video_count(tag) + download_count(tag)
  end
end
