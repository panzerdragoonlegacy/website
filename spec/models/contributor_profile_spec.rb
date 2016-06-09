require 'rails_helper'

RSpec.describe ContributorProfile, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:email_address) }
    it { is_expected.to respond_to(:avatar) }
    it { is_expected.to respond_to(:website) }
    it { is_expected.to respond_to(:facebook_username) }
    it { is_expected.to respond_to(:twitter_username) }
    it { is_expected.to respond_to(:discourse_username) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:user).dependent(:destroy) }
    it { is_expected.to have_many(:news_entries).dependent(:destroy) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it { is_expected.to have_many(:articles) }
    it { is_expected.to have_many(:downloads) }
    it { is_expected.to have_many(:links) }
    it { is_expected.to have_many(:music_tracks) }
    it { is_expected.to have_many(:pictures) }
    it { is_expected.to have_many(:poems) }
    it { is_expected.to have_many(:quizzes) }
    it { is_expected.to have_many(:resources) }
    it { is_expected.to have_many(:stories) }
    it { is_expected.to have_many(:videos) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(50)
    end
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:avatar) }
    it do
      is_expected.to validate_attachment_content_type(:avatar)
        .allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:avatar).less_than(5.megabytes)
    end
  end

  describe 'slug' do
    context 'creating a new contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.build :valid_contributor_profile, name: 'Contributor 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        contributor_profile.save
        expect(contributor_profile.url).to eq 'contributor-1'
      end
    end

    context 'updating a contributor profile' do
      let(:contributor_profile) do
        FactoryGirl.create :valid_contributor_profile, name: 'Contributor 1'
      end

      it 'synchronises the slug with the updated name' do
        contributor_profile.name = 'Contributor 2'
        contributor_profile.save
        expect(contributor_profile.url).to eq 'contributor-2'
      end
    end
  end
end
