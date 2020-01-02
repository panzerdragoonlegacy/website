require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:short_name_for_saga) }
    it { is_expected.to respond_to(:short_name_for_media_type) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:category_type) }
    it { is_expected.to respond_to(:category_picture) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category_group) }
    it { is_expected.to belong_to(:saga) }
    it { is_expected.to have_many(:pages).dependent(:destroy) }
    it { is_expected.to have_many(:articles).dependent(:destroy) }
    it { is_expected.to have_many(:downloads).dependent(:destroy) }
    it { is_expected.to have_many(:encyclopaedia_entries).dependent(:destroy) }
    it { is_expected.to have_many(:links).dependent(:destroy) }
    it { is_expected.to have_many(:music_tracks).dependent(:destroy) }
    it { is_expected.to have_many(:news_entries).dependent(:destroy) }
    it { is_expected.to have_many(:pictures).dependent(:destroy) }
    it { is_expected.to have_many(:resources).dependent(:destroy) }
    it { is_expected.to have_many(:stories).dependent(:destroy) }
    it { is_expected.to have_many(:videos).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it do
      is_expected.to validate_length_of(:short_name_for_saga).is_at_most(50)
    end
    it do
      is_expected.to validate_length_of(:short_name_for_media_type)
        .is_at_most(50)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category_type) }

    describe 'validation of category group' do
      context 'category type is also a category group type' do
        before do
          @category_group = FactoryGirl.create(
            :valid_category_group,
            category_group_type: :music_track
          )
          @category = FactoryGirl.build(
            :valid_category,
            category_type: :music_track
          )
        end

        context 'category group is present' do
          context "category type matches the group's type" do
            it 'should be valid' do
              @category.category_group = @category_group
              expect(@category).to be_valid
            end
          end

          context "category type does not match the group's type" do
            it 'should not be valid' do
              different_category_group = FactoryGirl.create(
                :valid_category_group,
                category_group_type: :video
              )
              @category.category_group = different_category_group
              expect(@category).not_to be_valid
            end
          end
        end

        context 'category group is missing' do
          it 'should not be valid' do
            @category.category_group = nil
            expect(@category).not_to be_valid
          end
        end
      end

      context 'category type is not a category group type' do
        before do
          @category = FactoryGirl.build(
            :valid_category,
            category_type: :link
          )
        end

        it 'should not validate if a category group is present' do
          category_group = FactoryGirl.create(
            :valid_category_group,
            category_group_type: :music_track
          )
          @category.category_group = category_group
          expect(@category).not_to be_valid
        end

        it 'should validate if a category group is missing' do
          @category.category_group = nil
          expect(@category).to be_valid
        end
      end
    end
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:category_picture) }
    it do
      is_expected.to validate_attachment_content_type(:category_picture)
        .allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:category_picture)
        .less_than(5.megabytes)
    end
  end

  describe 'slug' do
    context 'creating a new category' do
      let(:category) do
        FactoryGirl.build :valid_category, name: 'Category 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        category.save
        expect(category.url).to eq 'category-1'
      end
    end

    context 'updating a category' do
      let(:category) do
        FactoryGirl.create :valid_category, name: 'Category 1'
      end

      it 'synchronises the slug with the updated name' do
        category.name = 'Category 2'
        category.save
        expect(category.url).to eq 'category-2'
      end
    end
  end
end
