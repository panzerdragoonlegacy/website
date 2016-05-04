require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:description) }
    it { should respond_to(:information) }
    it { should respond_to(:picture) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
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
      before do
        @contributor_profile = FactoryGirl.create :valid_contributor_profile
        @picture = FactoryGirl.create :valid_picture
      end

      context 'picture has less than one contributor profile' do
        before do
          @picture.contributor_profiles = []
        end

        it 'should not be valid' do
          expect(@picture).not_to be_valid
        end
      end

      context 'picture has at least one contributor profile' do
        before do
          @picture.contributor_profiles << @contributor_profile
        end

        it 'should be valid' do
          expect(@picture).to be_valid
        end
      end
    end
  end

  describe 'file attachment' do
    it { should have_attached_file(:picture) }
    it { should validate_attachment_presence(:picture) }
    it do
      should validate_attachment_content_type(:picture)
        .allowing('image/jpeg')
    end
    it do
      should validate_attachment_size(:picture).less_than(5.megabytes)
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
