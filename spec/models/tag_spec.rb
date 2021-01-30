require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:wiki_slug) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:news_entries) }
    it { is_expected.to have_many(:pages) }
    it { is_expected.to have_many(:pictures) }
    it { is_expected.to have_many(:music_tracks) }
    it { is_expected.to have_many(:videos) }
    it { is_expected.to have_many(:downloads) }
    it { is_expected.to have_many(:quizzes) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:tag_picture) }
    it do
      is_expected.to validate_attachment_content_type(:tag_picture)
        .allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:tag_picture)
        .less_than(5.megabytes)
    end
  end
end
