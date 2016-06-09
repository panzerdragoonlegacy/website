require 'rails_helper'

RSpec.describe EncyclopaediaEntry, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:encyclopaedia_entry_picture) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_one(:saga).dependent(:destroy) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it do
      is_expected.to have_many(:contributor_profiles).through(:contributions)
    end
    it { is_expected.to have_many(:illustrations).dependent(:destroy) }
    it { is_expected.to have_many(:relations).dependent(:destroy) }
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

  describe 'nested attributes' do
    it do
      is_expected.to accept_nested_attributes_for(:illustrations)
        .allow_destroy(true)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:information) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:category) }
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:encyclopaedia_entry_picture) }
    it do
      is_expected.to validate_attachment_presence(:encyclopaedia_entry_picture)
    end
    it do
      is_expected.to validate_attachment_content_type(
        :encyclopaedia_entry_picture
      ).allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:encyclopaedia_entry_picture)
        .less_than(5.megabytes)
    end
  end

  describe 'callbacks' do
    context 'before save' do
      it "sets the entry's picture file name to match the entry's name" do
        valid_encyclopaedia_entry = FactoryGirl.build :valid_encyclopaedia_entry
        valid_encyclopaedia_entry.name = 'New Name'
        valid_encyclopaedia_entry.save
        expect(valid_encyclopaedia_entry.encyclopaedia_entry_picture_file_name)
          .to eq 'new-name.jpg'
      end
    end
  end

  describe 'slug' do
    context 'creating a new encyclopaedia entry' do
      let(:encyclopaedia_entry) do
        FactoryGirl.build :valid_encyclopaedia_entry, name: 'Entry 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        encyclopaedia_entry.save
        expect(encyclopaedia_entry.url).to eq 'entry-1'
      end
    end

    context 'updating an encyclopaedia entry' do
      let(:encyclopaedia_entry) do
        FactoryGirl.create :valid_encyclopaedia_entry, name: 'Entry 1'
      end

      it 'synchronises the slug with the updated name' do
        encyclopaedia_entry.name = 'Entry 2'
        encyclopaedia_entry.save
        expect(encyclopaedia_entry.url).to eq 'entry-2'
      end
    end
  end
end
