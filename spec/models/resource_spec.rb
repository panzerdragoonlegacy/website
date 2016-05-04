require 'rails_helper'

RSpec.describe Resource, type: :model do
  describe 'fields' do
    it { should respond_to(:name) }
    it { should respond_to(:url) }
    it { should respond_to(:content) }
    it { should respond_to(:publish) }
    it { should respond_to(:category) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:contributions).dependent(:destroy) }
    it { should have_many(:contributor_profiles).through(:contributions) }
    it { should have_many(:illustrations).dependent(:destroy) }
    it { should have_many(:relations).dependent(:destroy) }
    it { should have_many(:encyclopaedia_entries).through(:relations) }
  end

  describe 'nested attributes' do
    it do
      should accept_nested_attributes_for(:illustrations).allow_destroy(true)
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
    it { should validate_presence_of(:content) }
    it { should validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      before do
        @contributor_profile = FactoryGirl.create :valid_contributor_profile
        @resource = FactoryGirl.create :valid_resource
      end

      context 'resource has less than one contributor profile' do
        before do
          @resource.contributor_profiles = []
        end

        it 'should not be valid' do
          expect(@resource).not_to be_valid
        end
      end

      context 'resource has at least one contributor profile' do
        before do
          @resource.contributor_profiles << @contributor_profile
        end

        it 'should be valid' do
          expect(@resource).to be_valid
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new resource' do
      let(:resource) do
        FactoryGirl.build :valid_resource, name: 'Resource 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        resource.save
        expect(resource.url).to eq 'resource-1'
      end
    end

    context 'updating a resource' do
      let(:resource) do
        FactoryGirl.create :valid_resource, name: 'Resource 1'
      end

      it 'synchronises the slug with the updated name' do
        resource.name = 'Resource 2'
        resource.save
        expect(resource.url).to eq 'resource-2'
      end
    end
  end
end
