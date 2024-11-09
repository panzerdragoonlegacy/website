require 'rails_helper'

RSpec.describe PicturesHelper, type: :helper do
  describe 'picture source link text' do
    it 'displays deviantart link text' do
      source_url =
        'https://www.deviantart.com/joelchan/art/Panzer-Dragoon-Remake-837945885'
      expect(picture_source_link_text(source_url)).to eq 'DeviantArt'
    end

    it 'displays instagram link text' do
      source_url = 'https://www.instagram.com/p/DBQzzxWTDV8/'
      expect(picture_source_link_text(source_url)).to eq 'Instagram'
    end

    it 'displays bluesky link text' do
      source_url =
        'https://bsky.app/profile/panzerdragoonlegacy.com/post/3l6rrvnmbfe2q'
      expect(picture_source_link_text(source_url)).to eq 'Bluesky'
    end

    it 'displays x link text when a twitter or x url is the source' do
      twitter_source_url =
        'https://twitter.com/PanzerLegacy/status/1847227069996122208'
      x_source_url = 'https://x.com/PanzerLegacy/status/1847227069996122208'
      expect(picture_source_link_text(twitter_source_url)).to eq 'X (Twitter)'
      expect(picture_source_link_text(x_source_url)).to eq 'X (Twitter)'
    end

    it 'displays external webpage link text by default' do
      source_url =
        'https://mastodon.online/@PanzerDragoonLegacy/113328014982224027'
      expect(picture_source_link_text(source_url)).to eq 'External Webpage'
    end
  end
end
