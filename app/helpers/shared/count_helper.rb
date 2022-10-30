module Shared::CountHelper
  def news_entry_count(owner)
    policy_scope(owner.news_entries).count
  end

  def literature_count(owner)
    policy_scope(owner.pages.where(page_type: :literature.to_s)).count
  end

  def picture_count(owner)
    policy_scope(owner.pictures).count
  end

  def music_track_count(owner)
    policy_scope(owner.music_tracks).count
  end

  def video_count(owner)
    policy_scope(owner.videos).count
  end

  def download_count(owner)
    policy_scope(owner.downloads).count
  end
end
