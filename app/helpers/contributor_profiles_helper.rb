module ContributorProfilesHelper
  def show_avatar(contributor_profile, style)
    img_tag_width = '0'
    img_tag_height = '0'
    contributor_profile.send('avatar').options[:styles].each do |key, value|
      if key == style
        img_tag_width = value.split('x')[0]
        img_tag_height = value.split('x')[1].split('#')[0]
      end
    end
    if contributor_profile.avatar.present?
      image_tag(
        contributor_profile.avatar.url(style),
        alt: contributor_profile.name,
        width: img_tag_width,
        height: img_tag_height
      )
    else
      image_tag(
        'default-avatar.jpg',
        alt: contributor_profile.name,
        width: img_tag_width,
        height: img_tag_height
      )
    end
  end

  def article_count(contributor_profile)
    policy_scope(contributor_profile.articles).count
  end

  def download_count(contributor_profile)
    policy_scope(contributor_profile.downloads).count
  end

  def link_count(contributor_profile)
    policy_scope(contributor_profile.links).count
  end

  def music_track_count(contributor_profile)
    policy_scope(contributor_profile.music_tracks).count
  end

  def news_entry_count(contributor_profile)
    policy_scope(contributor_profile.news_entries).count
  end

  def picture_count(contributor_profile)
    policy_scope(contributor_profile.pictures).count
  end

  def poem_count(contributor_profile)
    policy_scope(contributor_profile.poems).count
  end

  def quiz_count(contributor_profile)
    policy_scope(contributor_profile.quizzes).count
  end

  def resource_count(contributor_profile)
    policy_scope(contributor_profile.resources).count
  end

  def story_count(contributor_profile)
    policy_scope(contributor_profile.stories).count
  end

  def video_count(contributor_profile)
    policy_scope(contributor_profile.videos).count
  end

  def website_contributions_count(contributor_profile)
    news_entry_count(contributor_profile) +
    article_count(contributor_profile) +
    download_count(contributor_profile) +
    link_count(contributor_profile) +
    music_track_count(contributor_profile) +
    picture_count(contributor_profile) +
    poem_count(contributor_profile) +
    quiz_count(contributor_profile) +
    resource_count(contributor_profile) +
    story_count(contributor_profile) +
    video_count(contributor_profile)
  end
end
