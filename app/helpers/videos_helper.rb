module VideosHelper
  def video_source_link_text(source_url)
    return 'Twitter' if source_url.include? 'twitter.com'
    return 'YouTube' if source_url.include? 'youtube.com'
    'External Webpage'
  end
end
