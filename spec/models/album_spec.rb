require 'rails_helper'

RSpec.describe Album, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:source_url) }
    it { is_expected.to respond_to(:instagram_post_id) }
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:slug) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:information) }
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
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
    it { is_expected.to have_many(:pictures).dependent(:destroy) }
    it { is_expected.to have_many(:videos).dependent(:destroy) }
  end

  describe 'nested attributes' do
    it do
      is_expected.to accept_nested_attributes_for(:pictures).allow_destroy(true)
    end
    it do
      is_expected.to accept_nested_attributes_for(:videos).allow_destroy(true)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it do
      is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100)
    end
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description)
        .is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'album has less than one contributor profile' do
        let(:album) { FactoryBot.build(:valid_album, contributor_profiles: []) }

        it 'should not be valid' do
          expect(album).not_to be_valid
        end
      end

      context 'album has at least one contributor profile' do
        let(:album) do
          FactoryBot.build(
            :valid_album,
            contributor_profiles: [
              FactoryBot.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(album).to be_valid
        end
      end
    end
  end

  describe 'callbacks' do
    context 'after save' do
      describe 'synchronisation of album and picture categories' do
        before do
          category = FactoryBot.create :valid_picture_category
          @album = FactoryBot.create :valid_album, category: category
          @picture = FactoryBot.create :valid_picture, category: category
          @album.pictures << @picture
        end

        context 'album category has changed' do
          it "updates the album's pictures to match the album's category" do
            different_category = FactoryBot.create :valid_picture_category
            @album.category = different_category
            @album.save
            expect(@picture.category).to eq different_category
          end
        end

        context 'album category has not changed' do
          it "does not update the album's pictures" do
            picture_last_updated_at = @picture.updated_at
            @album.save
            expect(@picture.updated_at).to eq picture_last_updated_at
          end
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new album' do
      let(:album) { FactoryBot.build :valid_album, name: 'Album 1' }

      it 'sets the slug to be a parameterised version of the id + name' do
        album.save
        expect(album.to_param).to eq album.id.to_s + '-album-1'
      end
    end

    context 'updating an album' do
      let(:album) { FactoryBot.create :valid_album, name: 'Album 1' }

      it 'sets the slug to be a parameterised version of the id + updated ' \
           'name' do
        album.name = 'Album 2'
        album.save
        expect(album.to_param).to eq album.id.to_s + '-album-2'
      end
    end
  end
end
