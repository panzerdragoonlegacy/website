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

  def article_count(owner)
    policy_scope(owner.articles).count
  end

  def download_count(owner)
    policy_scope(owner.downloads).count
  end

  def link_count(owner)
    policy_scope(owner.links).count
  end

  def music_track_count(owner)
    policy_scope(owner.music_tracks).count
  end

  def news_entry_count(owner)
    policy_scope(owner.news_entries).count
  end

  def picture_count(owner)
    policy_scope(owner.pictures).count
  end

  def poem_count(owner)
    policy_scope(owner.poems).count
  end

  def quiz_count(owner)
    policy_scope(owner.quizzes).count
  end

  def resource_count(owner)
    policy_scope(owner.resources).count
  end

  def story_count(owner)
    policy_scope(owner.stories).count
  end

  def video_count(owner)
    policy_scope(owner.videos).count
  end

  def website_contributions_count(owner)
    news_entry_count(owner) +
    article_count(owner) +
    download_count(owner) +
    link_count(owner) +
    music_track_count(owner) +
    picture_count(owner) +
    poem_count(owner) +
    quiz_count(owner) +
    resource_count(owner) +
    story_count(owner) +
    video_count(owner)
  end
end
