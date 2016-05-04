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

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(55) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:contributor_profile) }
  end

  describe 'associations' do
    it { should belong_to(:contributor_profile) }
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
end
