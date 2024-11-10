require 'rails_helper'

RSpec.describe PicturesHelper, type: :helper do
  describe 'title in gallery' do
    context 'grouping into albums' do
      group_into_albums = true

      it 'displays album name when there is an album' do
        picture = FactoryBot.create :valid_picture
        album =
          FactoryBot.create :valid_album,
                            category: picture.category,
                            pictures: [picture]
        expect(title_in_gallery(group_into_albums, picture)).to eq album.name
      end

      it 'displays picture name when there is no album' do
        picture = FactoryBot.create :valid_picture
        expect(title_in_gallery(group_into_albums, picture)).to eq picture.name
      end
    end

    context 'not grouping into albums' do
      group_into_albums = false

      it 'displays picture name' do
        picture = FactoryBot.create :valid_picture
        album =
          FactoryBot.create :valid_album,
                            category: picture.category,
                            pictures: [picture]
        expect(title_in_gallery(group_into_albums, picture)).to eq picture.name
      end
    end
  end

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
