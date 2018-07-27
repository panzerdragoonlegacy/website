require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'fields' do
    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:description) }
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
    it { is_expected.to have_many(:taggings).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:taggings) }
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
    it { is_expected.to validate_presence_of(:description) }
    it do
      is_expected.to validate_length_of(:description).is_at_least(2)
        .is_at_most(250)
    end
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_presence_of(:category) }

    describe 'validation of contributor profiles' do
      context 'article has less than one contributor profile' do
        let(:article) do
          FactoryGirl.build(
            :valid_article,
            contributor_profiles: []
          )
        end

        it 'should not be valid' do
          expect(article).not_to be_valid
        end
      end

      context 'article has at least one contributor profile' do
        let(:article) do
          FactoryGirl.build(
            :valid_article,
            contributor_profiles: [
              FactoryGirl.create(:valid_contributor_profile)
            ]
          )
        end

        it 'should be valid' do
          expect(article).to be_valid
        end
      end
    end
  end

  describe 'slug' do
    context 'creating a new article' do
      let(:article) { FactoryGirl.build :valid_article, name: 'Article 1' }

      it 'generates a slug that is a parameterised version of the name' do
        article.save
        expect(article.url).to eq 'article-1'
      end
    end

    context 'updating an article' do
      let(:article) { FactoryGirl.create :valid_article, name: 'Article 1' }

      it 'synchronises the slug with the updated name' do
        article.name = 'Article 2'
        article.save
        expect(article.url).to eq 'article-2'
      end
    end
  end
end
