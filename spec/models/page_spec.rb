require 'rails_helper'

RSpec.describe Page, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:content) }
    it { is_expected.to respond_to(:publish) }
    it { is_expected.to respond_to(:created_at) }
    it { is_expected.to respond_to(:updated_at) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:illustrations).dependent(:destroy) }
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
  end

  describe 'slug' do
    context 'creating a new page' do
      let(:page) do
        FactoryGirl.build :valid_page, name: 'Page 1'
      end

      it 'generates a slug that is a parameterised version of the name' do
        page.save
        expect(page.url).to eq 'page-1'
      end
    end

    context 'updating a page' do
      let(:page) do
        FactoryGirl.create :valid_page, name: 'Page 1'
      end

      it 'synchronises the slug with the updated name' do
        page.name = 'Page 2'
        page.save
        expect(page.url).to eq 'page-2'
      end
    end
  end
end
