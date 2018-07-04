module Admin::HomeHelper
  def draft_news_entry_count
    policy_scope(NewsEntry.where(publish: false)).count
  end

  def draft_category_count
    policy_scope(Category.where(publish: false)).count
  end

  def draft_encyclopaedia_entry_count
    policy_scope(EncyclopaediaEntry.where(publish: false)).count
  end

  def draft_contributor_profile_count
    policy_scope(ContributorProfile.where(publish: false)).count
  end

  def draft_article_count
    policy_scope(Article.where(publish: false)).count
  end

  def draft_download_count
    policy_scope(Download.where(publish: false)).count
  end

  def draft_music_track_count
    policy_scope(MusicTrack.where(publish: false)).count
  end

  def draft_album_count
    policy_scope(Album.where(publish: false)).count
  end

  def draft_picture_count
    policy_scope(Picture.where(publish: false)).count
  end

  def draft_poem_count
    policy_scope(Poem.where(publish: false)).count
  end

  def draft_quiz_count
    policy_scope(Quiz.where(publish: false)).count
  end

  def draft_resource_count
    policy_scope(Resource.where(publish: false)).count
  end

  def draft_story_count
    policy_scope(Story.where(publish: false)).count
  end

  def draft_video_count
    policy_scope(Video.where(publish: false)).count
  end

  def draft_page_count
    policy_scope(Page.where(publish: false)).count
  end

  def draft_count
    draft_news_entry_count +
    draft_category_count +
    draft_encyclopaedia_entry_count +
    draft_contributor_profile_count +
    draft_article_count +
    draft_download_count +
    draft_music_track_count +
    draft_album_count +
    draft_picture_count +
    draft_poem_count +
    draft_quiz_count +
    draft_resource_count +
    draft_story_count +
    draft_video_count +
    draft_page_count
  end
end
