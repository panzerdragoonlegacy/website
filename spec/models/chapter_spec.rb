require 'rails_helper'

RSpec.describe Chapter, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:chapter_type) }
    it { is_expected.to respond_to(:number) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:story) }
    it { is_expected.to have_many(:illustrations).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it do
      is_expected.to accept_nested_attributes_for(:illustrations)
        .allow_destroy(true)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:number) }
    it do
      is_expected.to validate_numericality_of(:number).is_greater_than(0)
        .is_less_than(100)
    end
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'slug' do
    context 'creating a new chapter' do
      let(:story) { FactoryGirl.create :valid_story, name: 'Story Name' }
      let(:chapter) do
        FactoryGirl.build(
          :valid_chapter,
          number: 1,
          story: story
        )
      end

      context 'chapter is a regular chapter' do
        before do
          chapter.chapter_type = :regular_chapter
        end

        context 'chapter has a name' do
          before do
            chapter.name = 'Regular Chapter Name'
          end

          it 'generates a slug that is a parameterised version of the story ' \
            'name, chapter number, and chapter name when saved' do
            chapter.save
            expect(chapter.url).to eq 'story-name-1-regular-chapter-name'
          end
        end

        context 'chapter does not have a name' do
          before do
            chapter.name = ''
          end

          it 'generates a slug that is a parameterised version of the story ' \
            'name and chapter number when saved' do
            chapter.save
            expect(chapter.url).to eq 'story-name-1'
          end
        end
      end

      context 'chapter is not a regular chapter' do
        before do
          chapter.chapter_type = :prologue
        end

        context 'chapter has a name' do
          before do
            chapter.name = 'Prologue Name'
          end

          it 'generates a slug that is a parameterised version of the story ' \
            'name and chapter name when saved' do
            chapter.save
            expect(chapter.url).to eq 'story-name-prologue-name'
          end
        end

        context 'chapter does not have a name' do
          before do
            chapter.name = ''
          end

          it 'prevents the chapter from being saved' do
            expect(chapter).not_to be_valid
          end
        end
      end
    end

    context 'updating a chapter' do
      let(:story) { FactoryGirl.create :valid_story, name: 'Old Story Name' }
      let(:chapter) do
        FactoryGirl.create(
          :valid_chapter,
          number: 1,
          name: 'Old Chapter Name',
          story: story
        )
      end

      context 'chapter is a regular chapter' do
        before do
          chapter.chapter_type = :regular_chapter
        end

        context 'chapter is updated with a new name' do
          it 'synchronises the slug with a parameterised version of the ' \
            'updated story name, chapter number, and chapter name when saved' do
            story.name = 'New Story Name'
            story.save
            chapter.number = 2
            chapter.name = 'New Regular Chapter Name'
            chapter.save
            expect(chapter.url).to eq 'new-story-name-2-new-regular-chapter-' \
              'name'
          end
        end

        context 'chapter is updated to have no name' do
          it 'synchronises the slug with a parameterised version of the ' \
            'updated story name and chapter number when saved' do
            story.name = 'New Story Name'
            story.save
            chapter.number = 2
            chapter.name = ''
            chapter.save
            expect(chapter.url).to eq 'new-story-name-2'
          end
        end
      end

      context 'chapter is not a regular chapter' do
        before do
          chapter.chapter_type = :prologue
        end

        context 'chapter is updated with a new name' do
          it 'synchronises the slug with a parameterised version of the new ' \
            'story name and chapter name when saved' do
            story.name = 'New Story Name'
            story.save
            chapter.name = 'New Prologue Name'
            chapter.save
            expect(chapter.url).to eq 'new-story-name-new-prologue-name'
          end
        end

        context 'chapter is updated to have no name' do
          it 'prevents the chapter from being saved' do
            story.name = 'New Story Name'
            story.save
            chapter.name = ''
            chapter.save
            expect(chapter).not_to be_valid
          end
        end
      end
    end
  end
end
