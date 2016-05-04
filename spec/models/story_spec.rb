require 'rails_helper'

RSpec.describe Story, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:content) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should have_many(:chapters).dependent(:destroy) }
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:illustrations).dependent(:destroy) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:description) }
    it do
      should validate_length_of(:description).is_at_least(2).is_at_most(250)
    end
    it { should validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'story has less than one contributor profile' do
        let(:story) do
          FactoryGirl.build(
            :valid_story,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(story).not_to be_valid
        end
      end

      context 'story has at least one contributor profile' do
        let(:story) do
          FactoryGirl.build(
            :valid_story,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(story).to be_valid
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new story' do
      let(:story) do
        FactoryGirl.build :valid_story, name: 'Story 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        story.save
        expect(story.url).to eq 'story-1'
      end
    end

    context 'updating a story' do
      let(:story) do
        FactoryGirl.create :valid_story, name: 'Story 1'
      end

      it 'synchronises the slug with the updated name' do
        story.name = 'Story 2'
        story.save
        expect(story.url).to eq 'story-2'
      end
    end
  end

  describe 'chapter slugs' do
    let(:story) { FactoryGirl.create :valid_story, name: 'Old Story Name' }

    context 'updating a story with a regular chapter' do
      let(:chapter) do
        FactoryGirl.create(
          :regular_chapter,
          name: 'Regular Chapter Name',
          story: story
        )
      end

      it 'synchronises the chapter slug with a parameterised version of the ' \
        'updated story name as well as the chapter number and chapter name' do
        story.name = 'New Story Name'
        story.save
        expect(chapter.url).to eq 'new-story-name-1-regular-chapter-name'
      end
    end

    context 'updating a story with a chapter that is not a regular chapter' do
      let(:chapter) do
        FactoryGirl.create(
          :prologue,
          name: 'Prologue Name',
          story: story
        )
      end

      it 'synchronises the chapter slug with a parameterised version of the ' \
        'updated story name as well as the chapter name when saved' do
        story.name = 'New Story Name'
        story.save
        expect(chapter.url).to eq 'new-story-name-prologue-name'
      end
    end
  end
end
