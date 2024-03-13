module VideosHelper
  def video_source_link_text(source_url)
    if source_url.include?('twitter.com') || source_url.include?('x.com')
      return 'X (Twitter)'
    end
    return 'YouTube' if source_url.include? 'youtube.com'
    'External Webpage'
  end
end
