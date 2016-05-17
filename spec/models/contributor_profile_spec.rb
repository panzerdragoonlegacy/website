require 'rails_helper'

RSpec.describe ContributorProfile, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:email_address) }
    it { should respond_to(:avatar) }
    it { should respond_to(:website) }
    it { should respond_to(:facebook_username) }
    it { should respond_to(:twitter_username) }
    it { should respond_to(:discourse_username) }
    it { should respond_to(:publish) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should have_one(:user).dependent(:destroy) }
    it { should have_many(:news_entries).dependent(:destroy) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:articles) }
    it { should have_many(:downloads) }
    it { should have_many(:links) }
    it { should have_many(:music_tracks) }
    it { should have_many(:pictures) }
    it { should have_many(:poems) }
    it { should have_many(:quizzes) }
    it { should have_many(:resources) }
    it { should have_many(:stories) }
    it { should have_many(:videos) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }
  end

  describe 'file attachment' do
    it { should have_attached_file(:avatar) }
    it do
      should validate_attachment_content_type(:avatar).allowing('image/jpeg')
    end
    it { should validate_attachment_size(:avatar).less_than(5.megabytes) }
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
