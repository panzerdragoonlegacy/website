require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:picture) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it do
      is_expected.to have_many(:contributor_profiles).through(:contributions)
    end
    it { is_expected.to have_many(:relations).dependent(:destroy) }
    it { is_expected.to have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'picture has less than one contributor profile' do
        let(:picture) do
          FactoryGirl.build(
            :valid_picture,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(picture).not_to be_valid
        end
      end

      context 'picture has at least one contributor profile' do
        let(:picture) do
          FactoryGirl.build(
            :valid_picture,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(picture).to be_valid
        end
      end
    end
  end

  describe 'file attachment' do
    it { is_expected.to have_attached_file(:picture) }
    it { is_expected.to validate_attachment_presence(:picture) }
    it do
      is_expected.to validate_attachment_content_type(:picture)
        .allowing('image/jpeg')
    end
    it do
      is_expected.to validate_attachment_size(:picture).less_than(5.megabytes)
    end
  end

  describe 'callbacks' do
    context 'before save' do
      it "sets the picture file name to match the picture's name" do
        valid_picture = FactoryGirl.build :valid_picture, name: 'New Name'
        valid_picture.save
        expect(valid_picture.picture_file_name).to eq 'new-name.jpg'
      end
    end
  end

  describe 'slug' do
    context 'creating a new picture' do
      let(:picture) do
        FactoryGirl.build :valid_picture, name: 'Picture 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        picture.save
        expect(picture.url).to eq 'picture-1'
      end
    end

    context 'updating a picture' do
      let(:picture) do
        FactoryGirl.create :valid_picture, name: 'Picture 1'
      end

      it 'synchronises the slug with the updated name' do
        picture.name = 'Picture 2'
        picture.save
        expect(picture.url).to eq 'picture-2'
      end
    end
  end
end
