require 'rails_helper'

RSpec.describe Picture, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:sequence_number) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
    it { is_expected.to respond_to(:source_url) }
    it { is_expected.to respond_to(:instagram_post_id) }
    it { is_expected.to respond_to(:picture) }
    it { is_expected.to respond_to(:full_size_link) }
    it { is_expected.to respond_to(:controversial_content) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:category) }
    it { is_expected.to respond_to(:album) }
    it { is_expected.to respond_to(:id_of_picture_to_replace) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:contributions).dependent(:destroy) }
    it do
      is_expected.to have_many(:contributor_profiles).through(:contributions)
    end
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
    it { is_expected.to belong_to(:album).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:sequence_number) }
    it do
      is_expected.to validate_numericality_of(:sequence_number)
        .is_greater_than_or_equal_to(0).is_less_than_or_equal_to(999)
    end
    it { is_expected.to validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'picture has less than one contributor profile' do
        let(:picture) do
          FactoryBot.build(
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
          FactoryBot.build(
            :valid_picture,
            contributor_profiles: [
              FactoryBot.create(:valid_contributor_profile)
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
      is_expected.to validate_attachment_size(:picture).less_than(25.megabytes)
    end
  end

  describe 'callbacks' do
    context 'before save' do
      it "sets the picture file name to match the picture's name" do
        valid_picture = FactoryBot.build :valid_picture, name: 'New Name'
        valid_picture.save
        expect(valid_picture.picture_file_name).to eq 'new-name.jpg'
      end

      describe 'replacement of picture' do
        before do
          @picture_to_replace = FactoryBot.create :valid_picture
          @picture_to_replace_id = @picture_to_replace.id
          @replacement_picture = FactoryBot.create :valid_picture
          @replacement_picture.id_of_picture_to_replace = @picture_to_replace.id
          @replacement_picture.save
        end

        context 'the picture is set to be published' do
          it 'deletes the specified picture to replace' do
            @replacement_picture.publish = true
            @replacement_picture.save
            expect(Picture.where(id: @picture_to_replace_id)).to eq []
          end
        end

        context 'the picture is not set to be published' do
          it 'does not delete the specified picture to replace' do
            @replacement_picture.publish = false
            @replacement_picture.save
            expect(
              Picture.where(id: @picture_to_replace_id)
            ).to eq([@picture_to_replace])
          end
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new picture' do
      let(:picture) do
        FactoryBot.build :valid_picture, name: 'Picture 1'
      end

      it 'sets the slug to be a parameterised version of the id + name' do
        picture.save
        expect(picture.to_param).to eq picture.id.to_s + '-picture-1'
      end
    end

    context 'updating a picture' do
      let(:picture) do
        FactoryBot.create :valid_picture, name: 'Picture 1'
      end

      it 'sets the slug to be a parameterised version of the id + updated ' \
        'name' do
        picture.name = 'Picture 2'
        picture.save
        expect(picture.to_param).to eq picture.id.to_s + '-picture-2'
      end
    end
  end
end
