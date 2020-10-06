require 'rails_helper'

RSpec.describe NewsEntry, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:summary) }
    it { is_expected.to respond_to(:news_entry_picture) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:contributor_profile) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
    it { is_expected.to respond_to(:published_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:contributor_profile) }
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(150)
    end
    it do
      is_expected.to validate_length_of(:summary).is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:contributor_profile) }
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:news_entry_picture) }
    it do
      is_expected.to validate_attachment_content_type(
        :news_entry_picture
      ).allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:news_entry_picture)
        .less_than(5.megabytes)
    end
  end

  describe 'callbacks' do
    context 'before save' do
      it "sets the entry's picture file name to match the entry's name" do
        valid_news_entry = FactoryBot.build :valid_news_entry
        valid_news_entry.name = 'New Name'
        valid_news_entry.save
        expect(valid_news_entry.news_entry_picture_file_name)
          .to eq 'new-name.jpg'
      end
    end
  end

  describe 'slug' do
    context 'creating a new news entry' do
      let(:news_entry) do
        FactoryBot.build :valid_news_entry, name: 'News Entry 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        news_entry.save
        expect(news_entry.url).to eq 'news-entry-1'
      end
    end

    context 'updating a news entry' do
      let(:news_entry) do
        FactoryBot.create :valid_news_entry, name: 'News Entry 1'
      end

      it 'synchronises the slug with the updated name' do
        news_entry.name = 'News Entry 2'
        news_entry.save
        expect(news_entry.url).to eq 'news-entry-2'
      end
    end
  end

  describe 'publication of news entry' do
    context 'the published date is not already set' do
      context 'the publish flag is set' do
        let(:news_entry) do
          FactoryBot.build :valid_news_entry, publish: true, published_at: nil
        end

        it 'sets a new published date when saved' do
          news_entry.save
          expect(news_entry.published_at).not_to eq nil
        end

        it 'publishes the news entry when saved' do
          news_entry.save
          expect(news_entry.publish).to be true
        end
      end

      context 'the published flag is not set' do
        let(:news_entry) do
          FactoryBot.build :valid_news_entry, publish: false, published_at: nil
        end

        it 'does not set a published date when saved' do
          news_entry.save
          expect(news_entry.published_at).to eq nil
        end

        it 'does not publish the news entry when saved' do
          news_entry.save
          expect(news_entry.publish).to be false
        end
      end
    end

    context 'the published date is already set' do
      let(:previously_set_published_at) { DateTime.current }

      context 'the publish flag is set' do
        let(:news_entry) do
          FactoryBot.create(
            :valid_news_entry,
            publish: true,
            published_at: previously_set_published_at
          )
        end

        it 'does not replace the published date when saved' do
          news_entry.save
          expect(news_entry.published_at).to eq previously_set_published_at
        end

        it 'publishes the news entry when saved' do
          news_entry.save
          expect(news_entry.publish).to be true
        end
      end

      context 'the published flag is not set' do
        let(:news_entry) do
          FactoryBot.create(
            :valid_news_entry,
            publish: false,
            published_at: previously_set_published_at
          )
        end

        it 'does not replace the published date when saved' do
          news_entry.save
          expect(news_entry.published_at).to eq previously_set_published_at
        end

        it 'does not publish the news entry when saved' do
          news_entry.save
          expect(news_entry.publish).to be false
        end
      end
    end
  end
end
