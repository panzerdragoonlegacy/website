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
      image_pack_tag(
        'media/images/default-avatar.jpg',
        alt: contributor_profile.name,
        width: img_tag_width,
        height: img_tag_height
      )
    end
  end

  def website_contributions_count(owner)
    news_entry_count(owner) + literature_count(owner) + picture_count(owner) +
      music_track_count(owner) + video_count(owner) + download_count(owner)
  end
end
