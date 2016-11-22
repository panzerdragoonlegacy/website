require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:content) }
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
    it { is_expected.to have_many(:illustrations).dependent(:destroy) }
    it { is_expected.to have_many(:relations).dependent(:destroy) }
    it { is_expected.to have_many(:encyclopaedia_entries).through(:relations) }
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
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'resource has less than one contributor profile' do
        let(:resource) do
          FactoryGirl.build(
            :valid_resource,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(resource).not_to be_valid
        end
      end

      context 'resource has at least one contributor profile' do
        let(:resource) do
          FactoryGirl.build(
            :valid_resource,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(resource).to be_valid
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new resource' do
      let(:resource) do
        FactoryGirl.build :valid_resource, name: 'Resource 1'
      end

      it 'sets the slug to be a parameterised version of the id + name' do
        resource.save
        expect(resource.to_param).to eq resource.id.to_s + '-resource-1'
      end
    end

    context 'updating a resource' do
      let(:resource) do
        FactoryGirl.create :valid_resource, name: 'Resource 1'
      end

      it 'sets the slug to be a parameterised version of the id + updated ' \
        'name' do
        resource.name = 'Resource 2'
        resource.save
        expect(resource.to_param).to eq resource.id.to_s + '-resource-2'
      end
    end
  end
end
