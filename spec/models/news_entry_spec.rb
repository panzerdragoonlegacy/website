require 'rails_helper'

RSpec.describe NewsEntry, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:content) }
    it { should respond_to(:short_url) }
    it { should respond_to(:publish) }
    it { should respond_to(:contributor_profile) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:published_at) }
  end

  describe 'associations' do
    it { should belong_to(:contributor_profile) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(55) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:contributor_profile) }
  end

  describe 'slug' do
    context 'creating a new news entry' do
      let(:news_entry) do
        FactoryGirl.build :valid_news_entry, name: 'News Entry 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        news_entry.save
        expect(news_entry.url).to eq 'news-entry-1'
      end
    end

    context 'updating a news entry' do
      let(:news_entry) do
        FactoryGirl.create :valid_news_entry, name: 'News Entry 1'
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
          FactoryGirl.build :valid_news_entry, publish: true, published_at: nil
        end

        it 'saving sets a new published date' do
          news_entry.save
          expect(news_entry.published_at).not_to eq nil
        end

        it 'saving publishes the news entry' do
          news_entry.save
          expect(news_entry.publish).to be true
        end
      end

      context 'the published flag is not set' do
        let(:news_entry) do
          FactoryGirl.build :valid_news_entry, publish: false, published_at: nil
        end

        it 'saving does not set a published date' do
          news_entry.save
          expect(news_entry.published_at).to eq nil
        end

        it 'saving does not publish the news entry' do
          news_entry.save
          expect(news_entry.publish).to be false
        end
      end
    end

    context 'the published date is already set' do
      let(:old_published_at) { DateTime.now }

      context 'the publish flag is set' do
        let(:news_entry) do
          FactoryGirl.create(
            :valid_news_entry,
            publish: true,
            published_at: old_published_at
          )
        end

        it 'saving does not replace the published date' do
          news_entry.save
          expect(news_entry.published_at).to eq old_published_at
        end

        it 'saving publishes the news entry' do
          news_entry.save
          expect(news_entry.publish).to be true
        end
      end

      context 'the published flag is not set' do
        let(:news_entry) do
          FactoryGirl.create(
            :valid_news_entry,
            publish: false,
            published_at: old_published_at
          )
        end

        it 'saving does not replace the published date' do
          news_entry.save
          expect(news_entry.published_at).to eq old_published_at
        end

        it 'saving does not publish the news entry' do
          news_entry.save
          expect(news_entry.publish).to be false
        end
      end
    end
  end
end
