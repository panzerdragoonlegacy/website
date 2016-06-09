require 'rails_helper'

RSpec.describe Poem, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
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
    it { is_expected.to validate_presence_of(:content) }

    describe 'validation of contributor profiles' do
      context 'poem has less than one contributor profile' do
        let(:poem) do
          FactoryGirl.build(
            :valid_poem,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(poem).not_to be_valid
        end
      end

      context 'poem has at least one contributor profile' do
        let(:poem) do
          FactoryGirl.build(
            :valid_poem,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(poem).to be_valid
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new poem' do
      let(:poem) do
        FactoryGirl.build :valid_poem, name: 'Poem 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        poem.save
        expect(poem.url).to eq 'poem-1'
      end
    end

    context 'updating a poem' do
      let(:poem) do
        FactoryGirl.create :valid_poem, name: 'Poem 1'
      end

      it 'synchronises the slug with the updated name' do
        poem.name = 'Poem 2'
        poem.save
        expect(poem.url).to eq 'poem-2'
      end
    end
  end
end
