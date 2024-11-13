require 'rails_helper'

RSpec.describe VideosHelper, type: :helper do
  describe 'video source link text' do
    it 'displays x link text when a twitter or x url is the source' do
      twitter_source_url =
        'https://twitter.com/PanzerDragoonRE/status/1310276551196512256'
      x_source_url = 'https://x.com/PanzerDragoonRE/status/1310276551196512256'
      expect(video_source_link_text(twitter_source_url)).to eq 'X (Twitter)'
      expect(video_source_link_text(x_source_url)).to eq 'X (Twitter)'
    end

    it 'displays youtube link text when youtube url is the source' do
      youtube_source_url = 'https://www.youtube.com/watch?v=lS0URL9xkQQ'
      expect(video_source_link_text(youtube_source_url)).to eq 'YouTube'
    end

    it 'displays external webpage link text by default' do
      source_url =
        'https://bsky.app/profile/panzerdragoondio.bsky.social/post/3l7vyxom5rl2v'
      expect(video_source_link_text(source_url)).to eq 'External Webpage'
    end
  end
end
